package module;

import haxe.io.Eof;

import pony.Fast;
import pony.Tools;

import sys.FileSystem;
import sys.io.Process;

import types.BAConfig;
import types.BASection;

using pony.text.XmlTools;

typedef HaxelibConfig = {
	> BAConfig,
	list: Array<{
		name: String,
		version: Null<String>,
		mute: Bool,
		git: Null<String>,
		warning: Bool,
		pony: Null<String>,
		haxe: Null<String>,
		haxelib: Null<String>,
		path: Null<String>,
		parent: Null<String>,
		y: Bool,
		commit: Null<String>
	}>
}

@SuppressWarnings('checkstyle:MagicNumber')
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract Source(String) from String to String {
	var GIT = 'git';
	var DEV = 'dev';
}

/**
 * Haxelib
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Haxelib extends CfgModule<HaxelibConfig> {

	private static inline var PRIORITY: Int = 1;

	public function new() super('haxelib');

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver < 4.2) override #end
	public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new HaxelibReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			list: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: HaxelibConfig): Void {
		for (lib in cfg.list) {
			if (lib.version == GIT && lib.git == null) continue;
			if (lib.version == DEV && lib.path == null) continue;
			Utils.command('haxelib', ['dev', lib.name]);
			var args: Array<String> =
				lib.version == GIT ? @:nullSafety(Off) [GIT, lib.name, lib.git] :
				lib.version == DEV && lib.path != null ? [DEV, lib.name, getLibPath(lib)] :
				lib.version != null ? ['install', lib.name, lib.version] : ['install', lib.name];
			if (lib.version == GIT && lib.commit != null) args.push(lib.commit);
			Sys.println('haxelib ' + args.join(' '));
			var process: Process = new Process('haxelib', args);
			try {
				while (true) {
					var ch = process.stdout.readString(1);
					Sys.print(ch);
					if (ch == '?') {
						process.stdin.writeString(lib.y ? 'y\n' : 'n\n');
						Sys.println(lib.y ? 'y\n' : 'n\n');
					}
				}
			} catch (e: Eof) {}
			try {
				while (true) Sys.stderr().writeString(process.stderr.readLine() + '\n');
			} catch (e: Eof) {}
			@:nullSafety(Off) var r: Int = process.exitCode();
			if (r > 0) error('haxelib error $r');
			if (lib.name == 'pony') {
				var exceptions: Array<Null<String>> = [null, 'dev', 'git'];
				if (!exceptions.contains(lib.version) && !exceptions.contains(Utils.ponyVersion) && lib.version != Utils.ponyVersion) {
					// Build and run new version
					Utils.command(
						'haxelib', ['run', 'pony', 'install', '-code', '-code-insiders', '-npm', '-userpath', '-nodepath', '-ponypath']
					);
					Utils.command('haxelib', ['run', 'pony', 'prepare']);
					Sys.exit(0);
				}
			} else {
				try {
					var path: String = Tools.libPath(lib.name);
					log('Lib installed to $path');
					var cwd: Cwd = new Cwd(path);
					var pony: String = path + 'pony.xml';
					if (FileSystem.exists(pony)) {
						cwd.sw();
						Utils.command('haxelib', ['run', 'pony', 'prepare']);
						if (lib.pony != null) Utils.command('haxelib', ['run', 'pony'].concat(lib.pony.split(' ')));
						cwd.sw();
					}
					if (lib.haxelib != null) {
						var haxelib: String = lib.haxelib;
						cwd.sw();
						Utils.command('haxelib', haxelib.split(' '));
						cwd.sw();
					}
					if (lib.haxe != null) {
						var haxe: String = lib.haxe;
						cwd.sw();
						Utils.command('haxe', haxe.split(' '));
						cwd.sw();
					}
				} catch (e: String) {
					error(e);
				}
			}
		}
	}

	private static inline function getLibPath(lib: {path: String, parent: Null<String>}): String {
		return lib.parent != null ? Tools.libPath(lib.parent) + lib.path : lib.path;
	}

}

@:nullSafety(Strict) private class HaxelibReader extends BAReader<HaxelibConfig> {

	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.list = [];
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'lib':
				var a: Array<String> = normalize(xml.innerData).split(' ');
				@:nullSafety(Off) var name: String = a[0];
				cfg.list.push({
					name: name,
					version: a[1],
					git: xml.has.git ? normalize(xml.att.git) : null,
					mute: xml.isTrue('mute'),
					warning: !xml.isFalse('warning'),
					pony: xml.has.pony ? normalize(xml.att.pony) : null,
					haxe: xml.has.haxe ? normalize(xml.att.haxe) : null,
					haxelib: xml.has.haxelib ? normalize(xml.att.haxelib) : null,
					path: xml.has.path ? normalize(xml.att.path) : null,
					parent: xml.has.parent ? normalize(xml.att.parent) : null,
					y: xml.isTrue('y'),
					commit: xml.has.commit ? normalize(xml.att.commit) : null
				});
			case _:
				super.readNode(xml);
		}
	}

}