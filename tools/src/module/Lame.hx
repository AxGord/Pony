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
 * Lame module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Lame extends CfgModule<LameConfig> {

	private static inline var PRIORITY: Int = 24;

	public function new() super('lame');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new LameReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: [],
			to: '',
			from: '',
			addext: '',
			preset: null,
			rm: false,
			hash: false,
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: LameConfig): Void {
		lameDirs(cfg.dirs, cfg.from, cfg.to, cfg.hash, cfg.addext, cfg.preset);
		lameUnits(cfg.units, cfg.from, cfg.to, cfg.hash, cfg.addext, cfg.preset, cfg.rm);
	}

	private function process(from: String, to: String, preset: Null<String>): Void {
		var args: Array<String> = [];
		if (preset != null) {
			args.push('--preset');
			args.push(preset);
		}
		args.push(from);
		args.push(to);
		Utils.command('lame', args);
	}

	private function replaceExt(s: String): String {
		return s.substr(0, -3) + 'mp3';
	}

	private function lameDirs(
		data: Array<Pair<String, Null<String>>>, from: Dir, to: Dir, hash: Bool, addext: String, preset: Null<String>
	): Void {
		var hashModule: Null<module.Hash> = hash ? modules.getModule(module.Hash) : null;
		for (d in data) {
			var dir: Dir = from + d.a;
			var filter: Null<String> = d.b;
			log('Lame directory: ${d.a}');
			if (hashModule != null && hashModule.xml != null) {
				for (f in dir.contentRecursiveFiles(filter)) {
					var w: Dir = to + f.fullDir.first.substr(dir.first.length);
					var k: String = w + replaceExt(f.name);
					if (!hashModule.fileChanged(k, f)) continue;
					Utils.createPath(k);
					process(f.first, k + addext, preset);
				}
			} else {
				for (f in dir.contentRecursiveFiles(filter)) {
					var w: Dir = to + f.fullDir.first.substr(dir.first.length);
					Utils.createPath(w);
					process(f.first, w + replaceExt(f.name) + addext, preset);
				}
			}
		}
	}

	private function lameUnits(
		data: Array<Triple<String, Null<String>, Null<String>>>, from: String, to: String,
		hash: Bool, addext: String, preset: Null<String>, rm: Bool
	): Void {
		var hashModule: Null<module.Hash> = hash ? modules.getModule(module.Hash) : null;
		for (p in data) {
			var unit: Unit = from + p.a;
			log('Lame file: $unit');
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
				process(unit.first, k + addext, preset);
				if (rm) unit.delete();
			} else {
				error('Is not file!');
			}
		}
	}

}

private typedef LameConfig = {
	> types.BAConfig,
	from: String,
	to: String,
	dirs: Array<Pair<String, Null<String>>>,
	units: Array<Triple<String, Null<String>, Null<String>>>,
	hash: Bool,
	addext: String,
	preset: Null<String>,
	rm: Bool
}

@:nullSafety(Strict) private class LameReader extends BAReader<LameConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'dir': cfg.dirs.push(new Pair(normalize(xml.innerData), xml.has.filter ? normalize(xml.att.filter) : '.wav'));
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
		cfg.preset = null;
		cfg.rm = false;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'to': cfg.to += val;
			case 'from': cfg.from += val;
			case 'hash': cfg.hash = val.isTrue();
			case 'addext': cfg.addext = val;
			case 'preset': cfg.preset = val;
			case 'rm': cfg.rm = val.isTrue();
			case _:
		}
	}

}