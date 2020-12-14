package module;

import pony.Fast;
import types.BAConfig;
import types.BASection;
import pony.text.TextTools;

typedef HaxelibConfig = { > BAConfig,
	list: Array<String>
}

/**
 * Haxelib
 * @author AxGord <axgord@gmail.com>
 */
class Haxelib extends CfgModule<HaxelibConfig> {

	private static inline var PRIORITY:Int = 1;

	public function new() super('haxelib');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new HaxelibReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			list: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:HaxelibConfig):Void {
		for (lib in cfg.list) {
			var args:Array<String> = ['install'];
			args = args.concat(lib.split(' '));
			args.push('--always');
			args.push('-R');
			args.push('http://lib.haxe.org/');
			Sys.command('haxelib', args);
		}
	}

}

private class HaxelibReader extends BAReader<HaxelibConfig> {

	override private function clean():Void {
		cfg.list = [];
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'lib': cfg.list.push(StringTools.trim(xml.innerData));
			case _: super.readNode(xml);
		}
	}

}