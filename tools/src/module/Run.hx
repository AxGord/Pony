package module;

import pony.Fast;

import types.BASection;
import types.BAConfig;

typedef RunConfig = {
	> BAConfig,
	?path: String,
	command: Array<{?path: String, cmd: String}>,
}

/**
 * Run module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Run extends CfgModule<RunConfig> {

	private static inline var PRIORITY: Int = 35;

	public function new() super('run');

	override public function init(): Void initSections(PRIORITY, BASection.Run);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new RunReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Run,
			path: null,
			command: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: RunConfig): Void {
		var path: String = cfg.path != null ? cfg.path : '';
		for (cmd in cfg.command) {
			var p: String = path + (cmd.path != null ? cmd.path : '');
			var cwd = new Cwd(p);
			if (p != '') cwd.sw();

			var args = cmd.cmd.split(' ');
			@:nullSafety(Off) var cmd: String = args.shift();
			Utils.command(cmd, args);

			if (p != '') cwd.sw();
		}
	}

}

private class RunReader extends BAReader<RunConfig> {

	override private function clean(): Void {
		cfg.path = null;
		cfg.command = [];
	}

	override private function readXml(xml: Fast): Void {
		try {
			cfg.command.push({cmd: normalize(xml.innerData)});
			for (a in xml.x.attributes())
				readAttr(a, normalize(xml.x.get(a)));
			if (allowEnd)
				end();
		} catch (e: Dynamic) {
			super.readXml(xml);
		}
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path':
				cfg.path = val;
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'command':
				cfg.command.push({cmd: normalize(xml.innerData), path: xml.has.path ? normalize(xml.att.path) : null});
			case 'haxe':
				cfg.command.push({cmd: 'haxe --run ' + normalize(xml.innerData), path: xml.has.path ? normalize(xml.att.path) : null});
			case 'lime':
				cfg.command.push({cmd: 'haxelib run lime ' + normalize(xml.innerData), path: xml.has.path ? normalize(xml.att.path) : null});
			case 'ax3':
				cfg.command.push({cmd: 'haxelib run ax3 ' + normalize(xml.innerData), path: xml.has.path ? normalize(xml.att.path) : null});
			case 'pony':
				cfg.command.push({cmd: 'haxelib run pony ' + normalize(xml.innerData), path: xml.has.path ? normalize(xml.att.path) : null});
			case 'formatter':
				cfg.command.push({
					cmd: 'haxelib run formatter -s ' + normalize(xml.innerData), path: xml.has.path ? normalize(xml.att.path) : null
				});
			case _:
				super.readNode(xml);
		}
	}

}