package module;

import pony.Fast;
import pony.text.TextTools;

import types.BAConfig;
import types.BASection;

using StringTools;
using pony.text.XmlTools;

typedef ElectronConfig = {
	> BAConfig,
	path: String,
	pack: Bool,
	config: Null<String>,
	name: Null<String>,
	version: Null<String>,
	author: Null<String>,
	description: Null<String>,
	artifactName: Null<String>,
	productName: Null<String>,
	copyright: Null<String>,
	category: Null<String>,
	os: Array<String>,
	arch: Array<String>
}

@:nullSafety(Strict) class Electron extends CfgModule<ElectronConfig> {

	private static inline var PRIORITY: Int = 0;

	public function new() super('electron');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Electron);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new ElectronReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Electron,
			allowCfg: true,
			path: 'bin/',
			pack: false,
			cordova: false,
			config: null,
			name: null,
			version: null,
			author: null,
			description: null,
			artifactName: null,
			productName: null,
			copyright: null,
			category: null,
			os: [],
			arch: []
		}, configHandler);
	}

	override private function runNode(cfg: ElectronConfig): Void {
		if (cfg.os.length > 0) {
			var cwd: Cwd = new Cwd(cfg.path);
			cwd.sw();
			var args: Array<String> = ['electron-builder'];

			if (cfg.name != null) {
				args.push('-c.extraMetadata.name');
				@:nullSafety(Off) args.push(cfg.name);
			}

			if (cfg.version != null) {
				args.push('-c.extraMetadata.version');
				@:nullSafety(Off) args.push(cfg.version);
			}

			if (cfg.author != null) {
				args.push('-c.extraMetadata.author');
				@:nullSafety(Off) args.push(cfg.author);
			}

			if (cfg.description != null) {
				args.push('-c.extraMetadata.description');
				@:nullSafety(Off) args.push(cfg.description);
			}

			if (cfg.productName != null) {
				args.push('-c.productName');
				@:nullSafety(Off) args.push(cfg.productName);
			}

			if (cfg.copyright != null) {
				args.push('-c.copyright');
				@:nullSafety(Off) args.push(cfg.copyright);
			}

			var linux: Bool = false;

			for (os in cfg.os) {
				args.push((os.length > 1 ? '-' : '') + '-$os');
				if ((os == 'l' || os == 'linux')) {
					linux = true;
					if (cfg.pack) args.push('appImage');
				}
			}

			if (linux && cfg.category != null) {
				args.push('-c.linux.category');
				@:nullSafety(Off) args.push(cfg.category);
			}

			if (cfg.artifactName != null) {
				args.push('-c.artifactName');
				@:nullSafety(Off) args.push(cfg.artifactName + (linux && cfg.pack ? '.AppImage' : ''));
			}

			for (arch in cfg.arch) args.push('--$arch');
			if (!cfg.pack) args.push('--dir');

			if (cfg.config != null) {
				args.push('-c');
				args.push('../${cfg.config}');
			}

			Utils.command('npx', args);
			cwd.sw();
		} else {
			log('OS not set, skip');
		}
	}

}

private class ElectronReader extends BAReader<ElectronConfig> {
	private static var SUPPORTED_OS: Array<String> = ['m', 'mac', 'macos', 'l', 'linux', 'w', 'win', 'windows'];
	private static var SUPPORTED_ARCH: Array<String> = ['x64', 'ia32', 'armv7l', 'arm64', 'universal'];

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.path = 'bin/';
		cfg.pack = false;
		cfg.config = null;
		cfg.name = null;
		cfg.version = null;
		cfg.author = null;
		cfg.description = null;
		cfg.artifactName = null;
		cfg.productName = null;
		cfg.copyright = null;
		cfg.category = null;
		cfg.os = [];
		cfg.arch = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path': cfg.path = val;
			case 'pack': cfg.pack = TextTools.isTrue(val);
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'name':
				var name: Null<String> = normalizeWithNull(xml.innerData);
				if (name != null) {
					if (xml.isTrue('rmspace')) name = name.replace(' ', '');
					if (xml.has.replaceSpace) name = name.replace(' ', xml.att.replaceSpace);
				}
				cfg.name = name;
			case 'version': cfg.version = normalizeWithNull(xml.innerData);
			case 'author': cfg.author = normalizeWithNull(xml.innerData);
			case 'description': cfg.description = normalizeWithNull(xml.innerData);
			case 'artifactName': cfg.artifactName = normalizeWithNull(xml.innerData);
			case 'productName': cfg.productName = normalizeWithNull(xml.innerData);
			case 'copyright': cfg.copyright = normalizeWithNull(xml.innerData);
			case 'category': cfg.category = normalizeWithNull(xml.innerData);
			case 'config': cfg.config = normalizeWithNull(xml.innerData);
			case 'os':
				var os: Null<String> = normalizeWithNull(xml.innerData);
				if (os != null) {
					if (SUPPORTED_OS.indexOf(os) == -1) Utils.error('Unsupported OS');
					cfg.os.push(os);
				}
			case 'arch':
				var arch: Null<String> = normalizeWithNull(xml.innerData);
				if (arch != null) {
					if (SUPPORTED_ARCH.indexOf(arch) == -1) Utils.error('Unsupported arch');
					cfg.arch.push(arch);
				}
			case _:
				super.readNode(xml);
		}
	}

}