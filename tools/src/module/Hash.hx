package module;

import haxe.crypto.Base64;
import haxe.crypto.Sha1;
import haxe.io.Bytes;
import haxe.xml.Printer;

import hxbitmini.Serializable;
import hxbitmini.Serializer;

import pony.Fast;
import pony.ds.STriple;
import pony.fs.Dir;
import pony.fs.File;

import types.BASection;

using StringTools;

using pony.text.TextTools;

/**
 * Hash module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Hash extends CfgModule<HashConfig> {

	public static inline var DEFAULT_FILE_NAME: String = 'hash.bin';
	private static inline var PRIORITY: Int = 40;

	public var runCleanAfter: Bool = false;
	private var updated: Bool = false;
	private var file: File = DEFAULT_FILE_NAME;
	private var binary: Bool = true;
	private var root: String = '';
	private var source: String = '';
	private var build: Null<String> = null;
	private var inited: Bool = false;
	private var units: Map<String, Bytes> = [];
	private var newUnits: Map<String, Bytes> = [];
	private var notChangedUnits: Array<String> = [];

	public function new() super('hash');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void {
		initSections(PRIORITY, BASection.Prepare);
		modules.commands.onHash < start;
		if (xml != null) modules.commands.onBuild.once(addToRun.bind(buildCompleteHandler), 100);
	}

	private function start(): Void error('Deprecated');

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new HashReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			file: DEFAULT_FILE_NAME,
			binary: true,
			allowCfg: true,
			root: '',
			source: '',
			build: null,
			input: [],
			cordova: false
		}, configHandler);
	}

	override private function configHandler(cfg: HashConfig): Void {
		super.configHandler(cfg);
		file = cfg.file;
		binary = cfg.binary;
		root = cfg.root;
		source = cfg.source;
		build = cfg.build;
	}

	private function buildCompleteHandler(): Void {
		if (build != null) {
			initHash();
			log('Copy files to build');
			for (file in (root: Dir).contentRecursiveFiles()) {
				var newContent: Null<String> = null;
				var f: String = file.first.substr(root.length);
				if (file.first == this.file.first) continue;
				var u: Null<Bytes> = units[f];
				if (u == null && f.endsWith('.bin')) u = units[f.substr(0, -4)];
				if (u == null && f.endsWith('.png')) u = units[f.substr(0, -4) + '.atlas'];
				if (u != null && f.endsWith('.fnt')) {
					var image: String = '';
					@:nullSafety(Off) var data: String = file.content;
					var xmlMode: Bool = false;
					try {
						var xml: Fast = new Fast(Xml.parse(data)).node.font;
						image = xml.node.pages.node.page.att.file;
						xmlMode = true;
					} catch (_: String) {
						var filePattern: String = '\npage id=0 file=';
						var fileIndex: Int = data.indexOf(filePattern);
						if (fileIndex != -1) {
							fileIndex += filePattern.length;
							image = data.substr(fileIndex);
							image = image.substr(0, image.indexOf('\n'));
						}
					}
					image = StringTools.replace(image, '"', '');
					var path: Null<String> = f.allBefore('/');
					var imgU: Null<Bytes> = units[path != null ? '$path/$image' : image];
					if (imgU != null) {
						log('Change font file in $file');
						var imageFile: File = image;
						var newFontName: String = [imageFile.withoutExt, Base64.urlEncode(imgU), imageFile.ext].join('.');
						if (xmlMode) {
							var xml: Fast = new Fast(Xml.parse(data)).node.font;
							xml.node.pages.node.page.x.set('file', newFontName);
							newContent = Printer.print(xml.x, true);
						} else {
							var filePattern: String = '\npage id=0 file=';
							var fileIndex: Int = data.indexOf(filePattern);
							if (fileIndex != -1) {
								fileIndex += filePattern.length;
								var endIndex: Int = data.indexOf('\n', fileIndex);
								newContent = data.substr(0, fileIndex) + '"$newFontName"' + data.substr(endIndex);
							}
						}
					}
				}
				if (u == null) {
					log('Warning: Hash for $f not found');
				} else {
					var f: File = f;
					var r: String = build + [f.withoutExt, Base64.urlEncode(u), f.ext].join('.');
					file.copyToFile(r);
					if (newContent != null) (r: File).content = newContent;
				}
			}
		}
		finishCurrentRun();
	}

	private function initHash(): Void {
		if (inited) return;
		inited = true;
		var bytes: Null<Bytes> = file.bytes;
		if (bytes != null) units = pony.ui.Hash.fromBytes(bytes).units;
	}

	private inline function pathKey(key: String): String {
		if (key.startsWith(root)) key = key.substr(root.length);
		if (key.startsWith(source)) key = key.substr(source.length);
		return key;
	}

	public function dirChanged(key: String, dirs: Array<String>, ?filter: String): Bool {
		initHash();
		key = pathKey(key);
		var dirs: Array<Dir> = [ for (dir in dirs) dir ];
		dirs.sort(cast Dir.compareNames);
		return compareStates(key, Sha1.make(DirState.fromDirs(dirs, filter)));
	}

	public function fileChanged(key: String, unit: File): Bool {
		if (unit.name == '.DS_Store') return false;
		initHash();
		var bytes: Null<Bytes> = Utils.gitHash(unit);
		return bytes == null ? true : compareStates(pathKey(key), bytes);
	}

	override private function runNode(cfg: HashConfig): Void {
		for (input in cfg.input) {
			var f: File = (root: Dir).file(input);
			if (!f.exists) return error('Hash input file not exists: $input');
			compareStates(input, Utils.gitHash(f));
		}
		var lost: Array<String> = getLost();
		if (lost.length > 0) updated = true;
		if (updated) {
			log('Write hash to ' + file);
			file.bytes = new pony.ui.Hash(newUnits).toBytes();
			if (runCleanAfter) {
				var cleanModule: Null<Clean> = modules.getModule(Clean);
				if (cleanModule != null) cleanModule.deleteUnits(lost);
			}
		}
	}

	private function compareStates(key: String, newState: Bytes): Bool {
		var oldState: Null<Bytes> = units[key];
		var changed: Bool = oldState == null || oldState.compare(newState) != 0;
		if (changed) {
			log('$key - changed');
			updated = true;
		} else {
			log('$key - not changed');
			notChangedUnits.push(key);
		}
		newUnits[key] = newState;
		return changed;
	}

	public function getHashed(): Array<String> {
		initHash();
		var r: Array<String> = buildUnitsList(units.keys());
		log('Keep $file');
		r.push(file.first);
		return r;
	}

	private function getLost(): Array<String> {
		return [ for (key in units.keys()) if (!newUnits.exists(key)) root + key ];
	}

	private function buildUnitsList(a: Iterator<String>): Array<String> {
		var r: Array<String> = [];
		for (key in a) {
			r.push(root + key);
			if (key.endsWith('.atlas')) {
				r.push(root + key.substr(0, -5) + 'png');
				r.push(root + key + '.bin');
			}
		}
		return r;
	}

	public inline function getNotChangedUnits(): Array<String> return buildUnitsList(notChangedUnits.iterator());

	public function getBuildResHashFile(): Null<STriple<String>> {
		return build != null ? @:nullSafety(Off) new STriple<String>(file.fullDir, build, file.name) : null;
	}

}

@:keep private class DirState implements Serializable {

	@:s public var units: Map<String, Bytes>;

	private function new(dirs: Array<Dir>, filter: Null<String>) {
		units = new Map<String, Bytes>();
		for (dir in dirs)
			for (file in dir.contentRecursiveFiles(filter, true)) if (file.name != '.DS_Store')
				units[file.first] = Utils.gitHash(file.first);
	}

	private inline function toBytes(): Bytes return new Serializer().serialize(this);
	public static inline function fromDirs(dirs: Array<Dir>, filter: Null<String>): Bytes return new DirState(dirs, filter).toBytes();

}

private typedef HashConfig = {
	> types.BAConfig,
	file: String,
	binary: Bool,
	root: String,
	source: String,
	build: Null<String>,
	input: Array<String>
}

@:nullSafety(Strict) private class HashReader extends BAReader<HashConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.file = module.Hash.DEFAULT_FILE_NAME;
		cfg.binary = true;
		cfg.root = '';
		cfg.source = '';
		cfg.build = null;
		cfg.input = [];
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'output': cfg.file = normalize(xml.innerData);
			case 'input': cfg.input.push(normalize(xml.innerData));
			case 'build': cfg.build = normalize(xml.innerData);
			case _: super.readNode(xml);
		}
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'binary': cfg.binary = !val.isFalse();
			case 'root': cfg.root = val;
			case 'source': cfg.source = val;
			case _:
		}
	}

}