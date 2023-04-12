package module;

import pony.Fast;
import pony.Pair;
import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Unit;

import types.BASection;

using pony.text.TextTools;

/**
 * Copy module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Copy extends CfgModule<CopyConfig> {

	private static inline var PRIORITY: Int = 21;

	public function new() super('copy');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new CopyReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: [],
			to: '',
			from: '',
			hash: false,
			addext: '',
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: CopyConfig): Void {
		copyDirs(cfg.dirs, cfg.from, cfg.to, cfg.hash, cfg.addext);
		copyUnits(cfg.units, cfg.from, cfg.to, cfg.hash, cfg.addext);
	}

	private function copyDirs(data: Array<Pair<String, Null<String>>>, from: String, to: String, hash: Bool, addext: String): Void {
		var hashModule: Null<module.Hash> = hash ? modules.getModule(module.Hash) : null;
		for (d in data) {
			var dir: Dir = from + d.a;
			var filter: Null<String> = d.b;
			log('Copy directory: ${d.a}');
			if (hashModule != null && hashModule.xml != null) {
				for (f in dir.contentRecursiveFiles(filter)) {
					if (!hashModule.fileChanged(f.first, f)) continue;
					var w: String = f.fullDir.first.substr(dir.first.length);
					Utils.createPath(to + w);
					f.copyToDir(to + w, f.name + addext);
				}
			} else {
				if (addext.length == 0) {
					Utils.createPath(to);
					dir.copyTo(to, filter);
				} else {
					for (f in dir.contentRecursiveFiles(filter)) {
						var w: String = f.fullDir.first.substr(dir.first.length);
						Utils.createPath(to + w);
						f.copyToDir(to + w, f.name + addext);
					}
				}
			}
		}
	}

	private function copyUnits(data: Array<Pair<String, Null<String>>>, from: String, to: String, hash: Bool, addext: String): Void {
		var hashModule: Null<module.Hash> = hash ? modules.getModule(module.Hash) : null;
		for (p in data) {
			var unit: Unit = from + p.a;
			log('Copy file: $unit');
			if (unit.isFile) {
				var unit: File = unit;
				if (hashModule != null && hashModule.xml != null && !hashModule.fileChanged(p.b != null ? from + p.b : unit.first, unit))
					continue;
				unit.copyToDir(to, Utils.replaceBuildDateIfNotNull(p.b != null ? p.b + addext : null));
			} else {
				error('Is not file!');
			}
		}
	}

}

private typedef CopyConfig = {
	> types.BAConfig,
	dirs: Array<Pair<String, Null<String>>>,
	units: Array<Pair<String, Null<String>>>,
	to: String,
	from: String,
	hash: Bool,
	addext: String
}

@:nullSafety(Strict) private class CopyReader extends BAReader<CopyConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'dir': cfg.dirs.push(new Pair(normalize(xml.innerData), xml.has.filter ? normalize(xml.att.filter) : null));
			case 'unit': cfg.units.push(new Pair(normalize(xml.innerData), xml.has.name ? xml.att.name : null));
			case _: super.readNode(xml);
		}
	}

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.dirs = [];
		cfg.units = [];
		cfg.to = '';
		cfg.from = '';
		cfg.hash = false;
		cfg.addext = '';
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'to': cfg.to += val;
			case 'from': cfg.from += val;
			case 'hash': cfg.hash = val.isTrue();
			case 'addext': cfg.addext = val;
			case _:
		}
	}

}