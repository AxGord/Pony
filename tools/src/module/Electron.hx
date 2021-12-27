package module;

import pony.Fast;
import pony.text.TextTools;

import types.BAConfig;
import types.BASection;

typedef ElectronConfig = {
	> BAConfig,
	path: String,
	mac: Bool,
	win: Bool,
	win32: Bool,
	linux: Bool,
	pack: Bool
}

class Electron extends CfgModule<ElectronConfig> {

	private static inline var PRIORITY: Int = 0;

	public function new() super('electron');

	override public function init(): Void initSections(PRIORITY, BASection.Electron);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new ElectronReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Electron,
			allowCfg: true,
			path: 'bin/',
			mac: false,
			win: false,
			win32: false,
			linux: false,
			pack: false,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: ElectronConfig): Void {
		if (cfg.mac || cfg.win || cfg.linux) {
			var cwd: Cwd = new Cwd(cfg.path);
			cwd.sw();
			var args: Array<String> = [];
			if (cfg.mac && cfg.win && cfg.linux) {
				args.push('-mwl');
			} else {
				if (cfg.linux) args.push('--linux');
				if (cfg.mac) args.push('--mac');
				if (cfg.win || cfg.win32) {
					args.push('--win');
					if (cfg.win32) args.push('--ia32');
				}
			}
			if (!cfg.pack) args.push('--dir');
			Utils.command('electron-builder', args);
			cwd.sw();
		}
	}

}

private class ElectronReader extends BAReader<ElectronConfig> {

	override private function clean(): Void {
		cfg.path = 'bin/';
		cfg.mac = false;
		cfg.win = false;
		cfg.win32 = false;
		cfg.linux = false;
		cfg.pack = false;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path': cfg.path = normalize(val);
			case 'mac': cfg.mac = TextTools.isTrue(val);
			case 'win': cfg.win = TextTools.isTrue(val);
			case 'win32': cfg.win32 = TextTools.isTrue(val);
			case 'linux': cfg.linux = TextTools.isTrue(val);
			case 'pack': cfg.pack = TextTools.isTrue(val);
			case _:
		}
	}

}