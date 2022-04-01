package module;

import pony.Fast;
import pony.Pair;
import pony.ds.Triple;
import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Unit;

import types.BASection;

using pony.text.TextTools;

/**
 * Oggenc module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Oggenc extends CfgModule<OggencConfig> {

	private static inline var PRIORITY: Int = 24;

	public function new() super('oggenc');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new OggencReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: [],
			to: '',
			from: '',
			addext: '',
			q: 3,
			rm: false,
			hash: false,
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: OggencConfig): Void {
		oggencDirs(cfg.dirs, cfg.from, cfg.to, cfg.hash, cfg.addext, cfg.q);
		oggencUnits(cfg.units, cfg.from, cfg.to, cfg.hash, cfg.addext, cfg.q, cfg.rm);
	}

	private function process(from: String, to: String, q: UInt): Void {
		Utils.command('oggenc', ['-q', '$q', '-o', to, from]);
	}

	private function replaceExt(s: String): String {
		return s.substr(0, -3) + 'ogg';
	}

	private function oggencDirs(
		data: Array<Pair<String, Null<String>>>, from: Dir, to: Dir, hash: Bool, addext: String, q: UInt
	): Void {
		var hashModule: Null<module.Hash> = hash ? modules.getModule(module.Hash) : null;
		for (d in data) {
			var dir: Dir = from + d.a;
			var filter: Null<String> = d.b;
			log('Oggenc directory: ${d.a}');
			if (hashModule != null && hashModule.xml != null) {
				for (f in dir.contentRecursiveFiles(filter)) {
					var w: Dir = to + f.fullDir.first.substr(dir.first.length);
					var k: String = w + replaceExt(f.name);
					if (!hashModule.fileChanged(k, f)) continue;
					Utils.createPath(k);
					process(f.first, k + addext, q);
				}
			} else {
				for (f in dir.contentRecursiveFiles(filter)) {
					var w: Dir = to + f.fullDir.first.substr(dir.first.length);
					Utils.createPath(w);
					process(f.first, w + replaceExt(f.name) + addext, q);
				}
			}
		}
	}

	private function oggencUnits(
		data: Array<Triple<String, Null<String>, Null<String>>>, from: String, to: String, hash: Bool, addext: String, q: UInt, rm: Bool
	): Void {
		var hashModule: Null<module.Hash> = hash ? modules.getModule(module.Hash) : null;
		for (p in data) {
			var unit: Unit = from + p.a;
			log('Oggenc file: $unit');
			if (unit.isFile) {
				var unit: File = unit;
				var k: String = to + @:nullSafety(Off) replaceExt(p.b != null ? p.b : unit.name);
				if (hashModule != null && hashModule.xml != null) {
					if (p.c == null) {
						if (!hashModule.fileChanged(k, unit)) continue;
					} else if (!hashModule.dirChanged(k, @:nullSafety(Off) [p.c], 'wav')) {
						if (rm) unit.delete();
						continue;
					}
				}
				Utils.createPath(to);
				process(unit.first, k + addext, q);
				if (rm) unit.delete();
			} else {
				error('Is not file!');
			}
		}
	}

}

private typedef OggencConfig = {
	> types.BAConfig,
	from: String,
	to: String,
	dirs: Array<Pair<String, Null<String>>>,
	units: Array<Triple<String, Null<String>, Null<String>>>,
	hash: Bool,
	addext: String,
	q: UInt,
	rm: Bool
}

@:nullSafety(Strict) private class OggencReader extends BAReader<OggencConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'dir': cfg.dirs.push(new Pair(normalize(xml.innerData), xml.has.filter ? normalize(xml.att.filter) : 'wav'));
			case 'unit': cfg.units.push(new Triple(
				normalize(xml.innerData),
				xml.has.name ? normalize(xml.att.name) : null,
				xml.has.hashFrom ? normalize(xml.att.hashFrom) : null
			));
			case _: super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.dirs = [];
		cfg.units = [];
		cfg.to = '';
		cfg.from = '';
		cfg.hash = false;
		cfg.addext = '';
		cfg.q = 3;
		cfg.rm = false;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'to': cfg.to += val;
			case 'from': cfg.from += val;
			case 'hash': cfg.hash = val.isTrue();
			case 'addext': cfg.addext = val;
			case 'rm': cfg.rm = val.isTrue();
			case 'q': @:nullSafety(Off) cfg.q = Std.parseInt(val);
			case _:
		}
	}

}