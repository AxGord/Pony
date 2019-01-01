package module;

import haxe.xml.Fast;
import pony.fs.Unit;
import pony.fs.Dir;
import types.BASection;

/**
 * Clean module
 * @author AxGord <axgord@gmail.com>
 */
class Clean extends CfgModule<CleanConfig> {

	private static inline var PRIORITY:Int = 10;

	public function new() super('clean');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new CleanReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:CleanConfig):Void {
		cleanDirs(cfg.dirs);
		deleteUnits(cfg.units);
	}

	private function cleanDirs(data:Array<String>):Void {
		for (d in data) {
			log('Clean directory: $d');
			(d:Dir).deleteContent();
		}
	}

	private function deleteUnits(data:Array<String>):Void {
		for (u in data) {
			log('Delete file: $u');
			(u:Unit).delete();
		}
	}

}

private typedef CleanConfig = { > types.BAConfig,
	dirs: Array<String>,
	units: Array<String>
}

private class CleanReader extends BAReader<CleanConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'dir': cfg.dirs.push(StringTools.trim(xml.innerData));
			case 'unit': cfg.units.push(StringTools.trim(xml.innerData));

			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.dirs = [];
		cfg.units = [];
	}

}