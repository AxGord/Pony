package module;

import pony.Pair;
import pony.Fast;
import pony.fs.Unit;
import pony.fs.Dir;
import pony.fs.File;
import types.BASection;

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
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: CopyConfig): Void {
		copyDirs(cfg.dirs, cfg.from, cfg.to, cfg.filter);
		copyUnits(cfg.units, cfg.from, cfg.to);
	}

	private function copyDirs(data: Array<String>, from: String, to: String, filter: String): Void {
		for (d in data) {
			d = from + d;
			log('Copy directory: $d');
			(d : Dir).copyTo(to, filter);
		}
	}

	private function copyUnits(data: Array<Pair<String, String>>, from: String, to: String): Void {
		for (p in data) {
			var unit: Unit = from + p.a;
			log('Copy file: $unit');
			if (unit.isFile)
				(unit : File).copyToDir(to, Utils.replaceBuildDateIfNotNull(p.b));
			else
				error('Is not file!');
		}
	}

}

private typedef CopyConfig = {
	> types.BAConfig,
	dirs: Array<String>,
	units: Array<Pair<String, String>>,
	?filter: String,
	to: String,
	from: String
}

private class CopyReader extends BAReader<CopyConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path':
				selfCreate(xml);
			case 'dir':
				cfg.dirs.push(StringTools.trim(xml.innerData));
			case 'unit':
				cfg.units.push(new Pair(StringTools.trim(xml.innerData), xml.has.name ? xml.att.name : null));
			case _:
				super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.dirs = [];
		cfg.units = [];
		cfg.filter = null;
		cfg.to = '';
		cfg.from = '';
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'filter':
				cfg.filter = val;
			case 'to':
				cfg.to += val;
			case 'from':
				cfg.from += val;
			case _:
		}
	}

}