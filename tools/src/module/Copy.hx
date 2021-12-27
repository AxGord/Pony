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
class Copy extends CfgModule<CopyConfig> {

	private static inline var PRIORITY: Int = 21;

	public function new() super('copy');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

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
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: CopyConfig): Void {
		copyDirs(cfg.dirs, cfg.from, cfg.to, cfg.filter, cfg.hash);
		copyUnits(cfg.units, cfg.from, cfg.to, cfg.hash);
	}

	private function copyDirs(data: Array<String>, from: String, to: String, filter: String, hash: Bool): Void {
		var hashModule: Null<module.Hash> = hash ? modules.getModule(module.Hash) : null;
		for (d in data) {
			var dir: Dir = from + d;
			log('Copy directory: $d');
			if (hashModule != null && hashModule.xml != null) {
				for (f in dir.contentRecursiveFiles(filter)) {
					if (!hashModule.fileChanged(f.first, f)) continue;
					var w: String = f.fullDir.first.substr(dir.first.length);
					f.copyToDir(to + w);
				}
			} else {
				dir.copyTo(to, filter);
			}
		}
	}

	private function copyUnits(data: Array<Pair<String, String>>, from: String, to: String, hash: Bool): Void {
		var hashModule: Null<module.Hash> = hash ? modules.getModule(module.Hash) : null;
		for (p in data) {
			var unit: Unit = from + p.a;
			log('Copy file: $unit');
			if (unit.isFile) {
				var unit: File = unit;
				if (hashModule != null && hashModule.xml != null && !hashModule.fileChanged(p.b != null ? from + p.b : unit.first, unit))
					continue;
				unit.copyToDir(to, Utils.replaceBuildDateIfNotNull(p.b));
			} else {
				error('Is not file!');
			}
		}
	}

}

private typedef CopyConfig = {
	> types.BAConfig,
	dirs: Array<String>,
	units: Array<Pair<String, String>>,
	?filter: String,
	to: String,
	from: String,
	hash: Bool
}

private class CopyReader extends BAReader<CopyConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'dir': cfg.dirs.push(StringTools.trim(xml.innerData));
			case 'unit': cfg.units.push(new Pair(StringTools.trim(xml.innerData), xml.has.name ? xml.att.name : null));
			case _: super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.dirs = [];
		cfg.units = [];
		cfg.filter = null;
		cfg.to = '';
		cfg.from = '';
		cfg.hash = false;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'filter': cfg.filter = val;
			case 'to': cfg.to += val;
			case 'from': cfg.from += val;
			case 'hash': cfg.hash = val.isTrue();
			case _:
		}
	}

}