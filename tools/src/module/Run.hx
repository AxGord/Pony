package module;

import pony.Fast;
import types.BASection;
import types.BAConfig;

typedef RunConfig = { > BAConfig,
	path: String,
	cmd: String
}

/**
 * Run module
 * @author AxGord <axgord@gmail.com>
 */
class Run extends CfgModule<RunConfig> {

	private static inline var PRIORITY:Int = 0;

	public function new() super('run');

	override public function init():Void initSections(PRIORITY, BASection.Run);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new RunReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Run,
			path: null,
			cmd: null,
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:RunConfig):Void {
		var cwd = new Cwd(cfg.path);
		cwd.sw();

		var args = cfg.cmd.split(' ');
		var cmd = args.shift();
		Utils.command(cmd, args);

		cwd.sw();
	}

}

private class RunReader extends BAReader<RunConfig> {

	override private function clean():Void {
		cfg.path = null;
		cfg.cmd = null;
	}

	override private function readXml(xml:Fast):Void {
		for (a in xml.x.attributes()) readAttr(a, normalize(xml.x.get(a)));
		cfg.cmd = normalize(xml.innerData);
		if (allowEnd) end();
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'path': cfg.path = val;
			case _:
		}
	}

}