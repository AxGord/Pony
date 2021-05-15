package module;

import pony.Tools;
import pony.fs.Dir;
import pony.SPair;
import pony.ZipTool;
import pony.Fast;
import pony.fs.Unit;
import pony.fs.File;
import types.BASection;

using pony.text.TextTools;
using Lambda;

/**
 * Hashlink module
 * @author AxGord <axgord@gmail.com>
 */
class Hashlink extends CfgModule<HashlinkConfig> {

	private static inline var PRIORITY: Int = 10;

	public function new() super('hl');

	override public function init(): Void initSections(PRIORITY, BASection.Build);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new HashlinkReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: Build,
			output: null,
			hl: null,
			main: null,
			data: [],
			libs: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: HashlinkConfig): Void {
		var output: String = cfg.output.a;
		if (output == null) error('HL outout not set');
		if (output.charAt(0) == '/') error('Wrong output path');
		if (cfg.hl == null) error('HL binary not set');
		if (cfg.main == null) error('Main file not set');
		if (!(cfg.main: File).exists) error('Main file not found');
		if (cfg.output.b.isTrue()) {
			log('Clear ' + output);
			(output : Dir).deleteContent();
		} else if (cfg.output.b.toLowerCase() == 'rimraf') {
			log('Clear ' + output);
			Utils.command('rimraf', [output]);
		}
		var ignoreLibs: Array<String> = ['mysql.hdll', 'mysql.lib'].filter(
			function(lib: String): Bool return !cfg.libs.exists(function(f: String): Bool return lib.substr(0, f.length) == f)
		);
		ignoreLibs.push('.h');
		ignoreLibs.push('.c');
		output = output.setLast('/');
		switch cfg.hl {
			case 'mac':
				var runhl: String = Utils.libPath + 'redist/runhl.app.zip';
				ZipTool.unpackFile(runhl, output, true, ignoreLibs, function(s: String): Void log(s));
				output += 'Contents/';
				var o: String = output;
				output += 'Resources/';
				if (!Utils.isWindows) {
					Utils.command('chmod', ['+x', o + 'MacOS/runhl']);
					Utils.command('chmod', ['+x', output + 'hl']);
				}
			case _:
				ZipTool.unpackFile(cfg.hl, output, true, ignoreLibs, function(s: String): Void log(s));
		}
		(cfg.main: File).copyToDir(output, 'hlboot.dat');
		for (d in cfg.data) {
			var u: Unit = d.a + d.b;
			if (u.exists)
				u.copyTo(output + d.b);
			else
				error('data ' + u + ' not found');
		}
	}

}

private typedef HashlinkConfig = {
	> types.BAConfig,
	output: SPair<String>,
	hl: String,
	main: String,
	data: Array<SPair<String>>,
	libs: Array<String>
}

private class HashlinkReader extends BAReader<HashlinkConfig> {

	override private function readNode(xml: Fast): Void {
		switch xml.name {
			case 'output':
				cfg.output = new SPair(normalize(xml.innerData), normalize(xml.att.clean));
			case 'hl':
				cfg.hl = normalize(xml.innerData);
			case 'main':
				cfg.main = normalize(xml.innerData);
			case 'data':
				cfg.data.push(new SPair(normalize(xml.att.from), normalize(xml.innerData)));
			case 'lib':
				cfg.libs.push(normalize(xml.innerData));
			case _:
				super.readNode(xml);
		}
	}

	override private function clean(): Void {
		cfg.output = null;
		cfg.hl = null;
		cfg.main = null;
		cfg.data = [];
		cfg.libs = [];
	}

}