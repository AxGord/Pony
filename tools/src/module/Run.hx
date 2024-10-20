package module;

import pony.Fast;

import types.BAConfig;
import types.BASection;

using StringTools;
using pony.text.XmlTools;

typedef RunConfig = {
	> BAConfig,
	?path: String,
	?lib: String,
	haxelib: Array<String>,
	command: Array<{?path: String, ?lib: String, cmd: String}>,
}

/**
 * Run module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Run extends CfgModule<RunConfig> {

	private static inline var PRIORITY: Int = 35;
	private static inline var LIB: String = '-lib';

	private var haxelib: Array<String> = [];

	public function new() super('run');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void {
		@:nullSafety(Off) haxelib = modules.xml != null && modules.xml.hasNode.haxelib ?
			[ for (e in modules.xml.node.haxelib.nodes.lib) if (!e.isTrue('mute')) e.innerData.split(' ').join(':') ] : [];
		initSections(PRIORITY, BASection.Run);
	}

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new RunReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Run,
			path: null,
			lib: null,
			command: [],
			haxelib: haxelib,
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: RunConfig): Void {
		var path: String = cfg.path != null ? cfg.path : '';
		if (cfg.lib != null) {
			final lib:String = cfg.lib;
			log('Command in lib $lib');
			var libPath: Null<String> = Utils.getLibPath(lib);
			if (libPath == null) error('Lib $lib not found');
			path = '$libPath$path';
		}
		for (cmd in cfg.command) {
			var p: String = path + (cmd.path != null ? cmd.path : '');
			if (cmd.lib != null) {
				final lib:String = cmd.lib;
				log('Command in lib $lib');
				var libPath: Null<String> = Utils.getLibPath(lib);
				if (libPath == null) error('Lib $lib not found');
				p = '$libPath$p';
			}
			var cwd = new Cwd(p);
			if (p != '') cwd.sw();

			var args = cmd.cmd.split(' ');
			@:nullSafety(Off) var cmd: String = args.shift();
			Utils.command(cmd, args);

			if (p != '') cwd.sw();
		}
	}

}

@:nullSafety(Strict) private class RunReader extends BAReader<RunConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.path = null;
		cfg.lib = null;
		cfg.command = [];
	}

	override private function readXml(xml: Fast): Void {
		try {
			cfg.command.push({cmd: normalize(xml.innerData)});
			for (a in xml.x.attributes()) readAttr(a, normalize(xml.x.get(a)));
			if (allowEnd) end();
		} catch (e: Dynamic) {
			super.readXml(xml);
		}
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'path': cfg.path = val;
			case 'lib': cfg.lib = val;
			case _:
		}
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'command':
				cfg.command.push({cmd: normalize(xml.innerData), path: getPath(xml), lib: getLib(xml)});
			case 'haxe':
				var cmd: Array<String> = ['haxe'];
				if (xml.has.cp) cmd.push('-cp ' + normalize(xml.att.cp));
				for (lib in cfg.haxelib) cmd.push('-lib ' + normalize(lib));
				if (xml.has.d) for (d in normalize(xml.att.d).split(' ')) cmd.push('-D ' + d);
				cmd.push('--run ' + normalize(xml.innerData));
				cfg.command.push({cmd: cmd.join(' '), path: getPath(xml), lib: getLib(xml)});
			case 'lime':
				cfg.command.push({cmd: 'haxelib run lime ' + normalize(xml.innerData), path: getPath(xml), lib: getLib(xml)});
			case 'ax3':
				cfg.command.push({cmd: 'haxelib run ax3 ' + normalize(xml.innerData), path: getPath(xml), lib: getLib(xml)});
			case 'pony':
				cfg.command.push({cmd: 'haxelib run pony ' + normalize(xml.innerData), path: getPath(xml), lib: getLib(xml)});
			case 'formatter':
				cfg.command.push({
					cmd: 'haxelib run formatter -s ' + normalize(xml.innerData), path: getPath(xml), lib: getLib(xml)
				});
			case _:
				super.readNode(xml);
		}
	}

	private inline function getPath(xml: Fast): Null<String> {
		return xml.has.path ? normalize(xml.att.path) : null;
	}

	private inline function getLib(xml: Fast): Null<String> {
		return xml.has.lib ? normalize(xml.att.lib) : null;
	}


}