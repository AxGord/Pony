package module;

import haxe.Json;

import pony.Fast;
import pony.ds.Triple;
import pony.text.TextTools;

import sys.FileSystem;
import sys.io.File;

import types.BAConfig;
import types.BASection;

using pony.text.XmlTools;

typedef NpmConfig = {
	> BAConfig,
	name: Null<String>,
	main: Null<String>,
	path: String,
	autoinstall: Bool,
	list: Array<Triple<String, Bool, Bool>>
}

/**
 * Npm module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Npm extends CfgModule<NpmConfig> {

	private static inline var PRIORITY: Int = 2;
	private static inline var PACKAGE: String = 'package.json';

	public function new() super('npm');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new NpmReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			name: null,
			main: null,
			path: null,
			autoinstall: false,
			list: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: NpmConfig): Void {
		var cwd = new Cwd(cfg.path, true);
		cwd.sw();
		if (cfg.name != null && cfg.main != null) {
			var a: Array<String> = cfg.name.split('@');
			File.saveContent(PACKAGE, Json.stringify({
				main: cfg.main,
				name: a[0],
				version: a.length > 1 ? a[1] : '0.0.1'
			}, '\t'));
		} else if (FileSystem.exists(PACKAGE)) {
			Sys.command('npm', ['install']);
		}
		if (cfg.autoinstall) for (module in cfg.list) if (!Utils.isWindows || module.c)
			Sys.command('npm', ['install', module.a, '--prefix', './'].concat(module.b ? ['-D'] : []));
		cwd.sw();
	}

}

private class NpmReader extends BAReader<NpmConfig> {

	override private function clean(): Void {
		cfg.path = null;
		cfg.autoinstall = false;
		cfg.list = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path': cfg.path = val;
			case 'autoinstall': cfg.autoinstall = TextTools.isTrue(val);
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'module':
				cfg.list.push(new Triple(normalize(xml.innerData), xml.isTrue('dev'), !xml.isFalse('windows')));
			case 'name':
				cfg.name = normalize(xml.innerData);
			case 'main':
				cfg.main = normalize(xml.innerData);
			case _:
				super.readNode(xml);
		}
	}

}