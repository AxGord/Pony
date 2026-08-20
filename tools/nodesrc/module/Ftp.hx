package module;

#if (haxe_ver >= 4.000)
import js.lib.Error;
#else
import js.Error;
#end
import js.Node;
import pony.Logable;
import pony.NPM;
import pony.ds.ROArray;
import pony.events.Signal0;
import pony.fs.Dir;
import pony.fs.File;
import sys.FileSystem;
import types.FtpConfig;

using pony.text.TextTools;

/**
 * Ftp Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) final class Ftp extends NModule<FtpConfig> {

	#if (haxe_ver < 4.2) override #end
	private function run(cfg: FtpConfig): Void {
		tasks.add();
		final ftp: FtpInstance = new FtpInstance(cfg);
		ftp.onLog << eLog;
		ftp.onError << eError;
		ftp.onComplete < tasks.end;
	}

}

@:nullSafety(Strict) @:final private class FtpInstance extends Logable {

	private static inline final DELAY_TIMEOUT: Int = 2000;

	public static var ignore(default, null): ROArray<String> = ['.DS_Store', '.Spotlight-V100', '.Trashes', 'ehthumbs.db', 'Thumbs.db'];

	@:auto public var onComplete: Signal0;

	private final ftp: Dynamic;
	private final path: String;
	private final input: Array<String> = [];
	private final output: String;
	@:nullSafety(Off) private var inputIterator: Iterator<String>;
	@:nullSafety(Off) private var fileIterator: Iterator<File>;

	public function new(cfg: FtpConfig) {
		super();
		path = cfg.path;
		output = cfg.output;
		for (e in cfg.input) {
			if (e.charCodeAt(e.length - 1) == '*'.code) {
				final dir: Dir = path + e.substr(0, -1);
				for (unit in dir.content(true)) input.push(unit.toString().substr(path.length));
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
			final unit: String = inputIterator.next();
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

	private function pauseDeleteNext(): Void Node.setTimeout(deleteNext, DELAY_TIMEOUT);

	private function uploadNext(): Void {
		if (inputIterator.hasNext()) {
			final unit: String = inputIterator.next();
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

	private function checkIgnore(unit: String): Bool return ignore.indexOf(cast unit.allAfterLast('/')) != -1;

	private function uploadNextFile(): Void {
		if (fileIterator.hasNext()) {
			final fullunit: String = fileIterator.next();
			final unit: String = fullunit.substr(path.length);
			final a: Array<String> = unit.split('/');
			final na: Array<String> = [for (e in a) if (e != '') e];
			final dir: String = [for (i in 0...na.length - 1) na[i]].join('/');
			final _ftp: Dynamic = ftp;
			final file: String = na.join('/');
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
