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
	ia32: Bool,
	linux: Bool,
	armv7l: Bool,
	arm64: Bool,
	pack: Bool,
	config: String
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
			ia32: false,
			linux: false,
			pack: false,
			armv7l: false,
			arm64: false,
			cordova: false,
			config: null
		}, configHandler);
	}

	override private function runNode(cfg: ElectronConfig): Void {
		if (cfg.mac || cfg.win || cfg.linux) {
			var cwd: Cwd = new Cwd(cfg.path);
			cwd.sw();
			var args: Array<String> = ['electron-builder'];
			if (cfg.mac && cfg.win && cfg.linux) {
				args.push('-mwl');
			} else {
				if (cfg.linux) {
					args.push('--linux');
					if (cfg.pack) args.push('appImage');
				}
				if (cfg.mac) args.push('--mac');
				if (cfg.win) {
					args.push('--win');
				}
				if (cfg.armv7l) args.push('--armv7l');
				if (cfg.arm64) args.push('--arm64');
				if (cfg.ia32) args.push('--ia32');
			}
			if (!cfg.pack) args.push('--dir');

			if (cfg.config != null) {
				args.push('-c');
				args.push('../${cfg.config}');
			}

			Utils.command('npx', args);
			cwd.sw();
		}
	}

}

private class ElectronReader extends BAReader<ElectronConfig> {

	override private function clean(): Void {
		cfg.path = 'bin/';
		cfg.mac = false;
		cfg.win = false;
		cfg.ia32 = false;
		cfg.linux = false;
		cfg.armv7l = false;
		cfg.arm64 = false;
		cfg.pack = false;
		cfg.config = null;
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path': cfg.path = val;
			case 'mac': cfg.mac = TextTools.isTrue(val);
			case 'win': cfg.win = TextTools.isTrue(val);
			case 'ia32': cfg.ia32 = TextTools.isTrue(val);
			case 'linux': cfg.linux = TextTools.isTrue(val);
			case 'armv7l': cfg.armv7l = TextTools.isTrue(val);
			case 'arm64': cfg.arm64 = TextTools.isTrue(val);
			case 'pack': cfg.pack = TextTools.isTrue(val);
			case 'config': cfg.config = normalize(val);
			case _:
		}
	}

}