package module;

import haxe.io.Eof;
import sys.io.Process;
import pony.Fast;
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
		warning: Bool
	}>
}

/**
 * Haxelib
 * @author AxGord <axgord@gmail.com>
 */
class Haxelib extends CfgModule<HaxelibConfig> {

	private static inline var PRIORITY: Int = 1;

	public function new() super('haxelib');

	override public function init(): Void initSections(PRIORITY, BASection.Prepare);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new HaxelibReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Prepare,
			list: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: HaxelibConfig): Void {
		for (lib in cfg.list) {
			if (lib.version == 'git' && lib.git == null) continue;
			if (lib.version == 'dev') continue;
			var args: Array<String> = lib.version == 'git' ? ['git', lib.name, lib.git] :
				lib.version != null ? ['install', lib.name, lib.version] : ['install', lib.name];
			Sys.println('haxelib ' + args.join(' '));
			var process: Process = new Process('haxelib', args);
			try {
				while (true) {
					var ch = process.stdout.readString(1);
					Sys.print(ch);
					if (ch == '?') {
						process.stdin.writeString('n\n');
						Sys.println('');
					}
				}
			} catch (e: Eof) {}
			try {
				while (true) Sys.stderr().writeString(process.stderr.readLine() + '\n');
			} catch (e: Eof) {}
			var r: Int = process.exitCode();
			if (r > 0) error('haxelib error $r');
		}
	}

}

private class HaxelibReader extends BAReader<HaxelibConfig> {

	override private function clean(): Void {
		cfg.list = [];
	}

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'lib':
				var a: Array<String> = normalize(xml.innerData).split(' ');
				cfg.list.push({
					name: a[0],
					version: a[1],
					git: xml.has.git ? normalize(xml.att.git) : null,
					mute: xml.isTrue('mute'),
					warning: !xml.isFalse('warning')
				});
			case _:
				super.readNode(xml);
		}
	}

}