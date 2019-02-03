package module;

import pony.Pair;
import haxe.xml.Fast;
import pony.fs.Unit;
import pony.fs.Dir;
import pony.fs.File;
import types.BASection;

/**
 * Move module
 * @author AxGord <axgord@gmail.com>
 */
class Move extends CfgModule<MoveConfig> {

	public static inline var PRIORITY:Int = 20;

	public function new() super('move');
	
	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new MoveReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Prepare,
			dirs: [],
			units: [],
			to: '',
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:MoveConfig):Void {
		moveDirs(cfg.dirs, cfg.to, cfg.filter);
		moveUnits(cfg.units, cfg.to);
	}

	private function moveDirs(data:Array<String>, to:String, filter:String):Void {
		for (d in data) {
			log('Move directory: $d, to $to');
			(d:Dir).moveTo(to, filter);
		}
	}

	private function moveUnits(data:Array<Pair<String, String>>, to:String):Void {
		for (p in data) {
			var unit:Unit = p.a;
			log('Move file: $unit');
			if (unit.isFile) {
				(unit:File).moveToDir(to, Utils.replaceBuildDateIfNotNull(p.b));
			} else {
				error('Is not file!');
			}
		}
	}

}

private typedef MoveConfig = { > types.BAConfig,
	dirs: Array<String>,
	units: Array<Pair<String, String>>,
	?filter: String,
	to: String
}

private class MoveReader extends BAReader<MoveConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {

			case 'dir': cfg.dirs.push(StringTools.trim(xml.innerData));
			case 'unit': cfg.units.push(new Pair(StringTools.trim(xml.innerData), xml.has.name ? xml.att.name : null));

			case _: super.readNode(xml);
		}
	}

	override private function clean():Void {
		cfg.dirs = [];
		cfg.units = [];
		cfg.filter = null;
		cfg.to = '';
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'filter': cfg.filter = val;
			case 'to': cfg.to = val;
			case _:
		}
	}

}