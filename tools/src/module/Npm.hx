package module;

import pony.Pair;
import pony.Fast;
import pony.text.TextTools;

import sys.FileSystem;

import types.BAConfig;
import types.BASection;

typedef NpmConfig = { > BAConfig,
	path: String,
	autoinstall: Bool,
	list: Array<String>
}

/**
 * Npm module
 * @author AxGord <axgord@gmail.com>
 */
class Npm extends CfgModule<NpmConfig> {

	private static inline var PRIORITY:Int = 2;

	public function new() super('npm');

	override public function init():Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml:Fast, ac:AppCfg):Void {
		new NpmReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			path: null,
			autoinstall: false,
			list: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg:NpmConfig):Void {
		var cwd = new Cwd(cfg.path, true);
		cwd.sw();

		if (FileSystem.exists('package.json')) Sys.command('npm', ['install']);

		if (cfg.autoinstall) {
			for (module in cfg.list) {
				Sys.command('npm', ['install', module, '--prefix', './']);
			}
		}
		cwd.sw();
	}

}

private class NpmReader extends BAReader<NpmConfig> {

	override private function clean():Void {
		cfg.path = null;
		cfg.autoinstall = false;
		cfg.list = [];
	}

	override private function readAttr(name:String, val:String):Void {
		switch name {
			case 'path': cfg.path = val;
			case 'autoinstall': cfg.autoinstall = TextTools.isTrue(val);
			case _:
		}
	}

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'module': cfg.list.push(StringTools.trim(xml.innerData));
			case _: super.readNode(xml);
		}
	}

}