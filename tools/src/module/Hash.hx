package module;

import haxe.crypto.Sha224;
import haxe.io.Bytes;
import haxe.io.BytesOutput;

import hxbitmini.Serializable;
import hxbitmini.Serializer;

import pony.Fast;
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
	private var inited: Bool = false;
	private var units: Map<String, Bytes> = [];
	private var newUnits: Map<String, Bytes> = [];
	private var notChangedUnits: Array<String> = [];

	public function new() super('hash');

	override public function init(): Void {
		initSections(PRIORITY, BASection.Prepare);
		modules.commands.onHash < start;
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
		return compareStates(key, Sha224.make(DirState.fromDirs(dirs, filter)));
	}

	public function fileChanged(key: String, unit: File): Bool {
		if (unit.name == '.DS_Store') return false;
		initHash();
		key = pathKey(key);
		var date: Null<Date> = unit.mtime;
		if (date == null) return true;
		var bo: BytesOutput = new BytesOutput();
		bo.writeInt32(Std.int(date.getTime()));
		return compareStates(key, bo.getBytes());
	}

	override private function runNode(cfg: HashConfig): Void {
		for (input in cfg.input) {
			var bytes: Null<Bytes> = (root: Dir).file(input).bytes;
			if (bytes == null) return error('Hash input file not exists: $input');
			compareStates(input, Sha224.make(bytes));
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

}

@:keep private class DirState implements Serializable {

	@:s public var units: Map<String, UInt>;

	private function new(dirs: Array<Dir>, filter: Null<String>) {
		units = new Map<String, UInt>();
		for (dir in dirs) for (file in dir.contentRecursiveFiles(filter, true))
			if (file.name != '.DS_Store')
				units[file.first] = Std.int(file.mtime.getTime());
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
	input: Array<String>
}

@:nullSafety(Strict) private class HashReader extends BAReader<HashConfig> {

	override private function clean(): Void {
		cfg.file = module.Hash.DEFAULT_FILE_NAME;
		cfg.binary = true;
		cfg.root = '';
		cfg.source = '';
		cfg.input = [];
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'output': cfg.file = normalize(xml.innerData);
			case 'input': cfg.input.push(normalize(xml.innerData));
			case _: super.readNode(xml);
		}
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'binary': cfg.binary = !val.isFalse();
			case 'root': cfg.root = normalize(val);
			case 'source': cfg.source = normalize(val);
			case _:
		}
	}

}