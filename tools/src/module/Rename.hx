package module;

import pony.Fast;
import pony.Pair;
import pony.fs.Unit;

import types.BASection;

using pony.text.TextTools;

/**
 * Rename module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Rename extends CfgModule<RenameConfig> {

	private static inline var PRIORITY: Int = 21;

	public function new() super('rename');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new RenameReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			units: [],
			path: '',
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: RenameConfig): Void {
		renameUnits(cfg.units, cfg.path);
	}

	private function renameUnits(data: Array<Pair<String, Null<String>>>, path: String): Void {
		for (p in data) {
			var from: Unit = path + p.b;
			var to: Unit = path + p.a;
			log('Rename file: $from to $to');
			from.rename(to);
		}
	}

}

private typedef RenameConfig = {
	> types.BAConfig,
	units: Array<Pair<String, String>>,
	path: String
}

@:nullSafety(Strict) private class RenameReader extends BAReader<RenameConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'path': selfCreate(xml);
			case 'unit': cfg.units.push(new Pair(normalize(xml.innerData), xml.att.from));
			case _: super.readNode(xml);
		}
	}

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.units = [];
		cfg.path = '';
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path': cfg.path += val;
			case _:
		}
	}

}