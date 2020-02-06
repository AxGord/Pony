package module;

import types.FtpConfig;
import pony.events.Signal0;
import pony.Logable;
import pony.fs.File;
import pony.fs.Dir;
import pony.NPM;
#if (haxe_ver >= '4.0.0')
import js.lib.Error;
#else
import js.Error;
#end
import js.Node;
import sys.FileSystem;

import pony.ds.ROArray;

using pony.text.TextTools;

/**
 * Ftp
 * @author AxGord <axgord@gmail.com>
 */
class Ftp extends NModule<FtpConfig> {

	override private function run(cfg: FtpConfig): Void {
		tasks.add();
		var ftp: FtpInstance = new FtpInstance(cfg);
		ftp.onLog << eLog;
		ftp.onError << eError;
		ftp.onComplete < tasks.end;
	}

}

private class FtpInstance extends Logable {

	private static inline var DELAY_TIMEOUT: Int = 2000;

	public static var ignore(default, null): ROArray<String> = ['.DS_Store', '.Spotlight-V100', '.Trashes', 'ehthumbs.db', 'Thumbs.db'];

	@:auto public var onComplete: Signal0;

	private var ftp: Dynamic;
	private var path: String;
	private var input: Array<String> = [];
	private var output: String;
	private var inputIterator:Iterator<String>;
	private var fileIterator:Iterator<File>;

	public function new(cfg: FtpConfig) {
		super();
		path = cfg.path;
		output = cfg.output;
		for (e in cfg.input) {
			if (e.charCodeAt(e.length - 1) == '*'.code) {
				var dir: Dir = path + e.substr(0, -1);
				for (unit in dir.content(true))
					input.push(unit.toString().substr(path.length));
			} else {
				input.push(e);
			}
		}
		ftp = Type.createInstance(NPM.ftp, []);
		ftp.on('ready', readyHandler);
		ftp.on('error', errorHandler);
		ftp.connect({
			host: cfg.host,
			port: cfg.port,
			user: cfg.user,
			password: cfg.pass
		});
	}

	private function errorHandler(err: Error): Void {
		error(err.message);
		eComplete.dispatch();
	}

	private function readyHandler(): Void {
		log('Cwd: $output');
		ftp.binary(binaryHandler);
	}

	private function binaryHandler(): Void {
		ftp.cwd(output, cwdHandler);
	}

	private function cwdHandler(e: Error): Void {
		if (e != null) throw e;
		log('Delete old files');
		inputIterator = input.iterator();
		deleteNext();
	}

	private function deleteNext(): Void {
		if (inputIterator.hasNext()) {
			var unit: String = inputIterator.next();
			log('Delete: $unit');
			if (FileSystem.isDirectory(path + unit))
				ftp.rmdir(unit, true, pauseDeleteNext);
			else
				ftp.delete(unit, deleteNext);
		} else {
			log('Finish delete');
			log('Upload new files');
			inputIterator = input.iterator();
			uploadNext();
		}
	}

	private function pauseDeleteNext(): Void {
		Node.setTimeout(deleteNext, DELAY_TIMEOUT);
	}

	private function uploadNext(): Void {
		if (inputIterator.hasNext()) {
			var unit: String = inputIterator.next();
			if (FileSystem.isDirectory(path + unit)) {
				fileIterator = new Dir(path + unit).contentRecursiveFiles().iterator();
				uploadNextFile();
			} else {
				if (!checkIgnore(unit)) {
					log('Upload file: $unit');
					ftp.put(path + unit, unit, false, uploadNext);
				} else {
					log('Ignore file: $unit');
					uploadNext();
				}
			}
		} else {
			log('Finish upload');
			ftp.end();
			eComplete.dispatch();
		}
	}

	private function checkIgnore(unit: String): Bool return ignore.indexOf(unit.allAfterLast('/')) != -1;

	private function uploadNextFile(): Void {
		if (fileIterator.hasNext()) {
			var fullunit: String = fileIterator.next();
			var unit: String = fullunit.substr(path.length);
			var a: Array<String> = unit.split('/');
			var na: Array<String> = [for (e in a) if (e != '') e];
			var dir: String = [for (i in 0...na.length - 1) na[i]].join('/');
			var _ftp: Dynamic = ftp;
			var file: String = na.join('/');
			log('Makedir: $dir');
			ftp.mkdir(dir, true, function(): Void {
				if (!checkIgnore(file)) {
					log('Upload file: $file');
					_ftp.put(path + file, file, false, uploadNextFile);
				} else {
					log('Ignore file: $unit');
					uploadNextFile();
				}
			});
		} else {
			uploadNext();
		}
	}

}