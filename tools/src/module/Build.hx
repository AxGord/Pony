package module;

import pony.Fast;
import types.BASection;
import sys.FileSystem;
import sys.io.File;
import sys.net.Socket;
import sys.net.Host;

typedef LastCompilationOptions = {
	command:Array<String>,
	debug:Bool,
	compiler:String
}

/**
 * Build module
 * @author AxGord <axgord@gmail.com>
 */
class Build extends CfgModule<BuildConfig> {

	private static inline var PRIORITY: Int = 1;
	private static inline var TIMEOUT: Int = 5;

	private var flags(default, null): Array<String> = [];
	private var haxelib: Array<String> = [];
	private var postHaxelibs: Array<String> = [];
	private var server: Bool = false;
	private var lastCompilationOptions: LastCompilationOptions;
	private var tryCounter: Int;

	public function new() super('build');

	override public function init(): Void {
		if (xml == null) return;
		if (modules.xml.hasNode.haxelib) {
			for (e in modules.xml.node.haxelib.nodes.lib) {
				var a = e.innerData.split(' ');
				haxelib.push('-lib');
				haxelib.push(a.join(':'));
			}
		}
		server = modules.xml.hasNode.server && modules.xml.node.server.hasNode.haxe;
		initSections(PRIORITY, BASection.Build);
	}

	public function addHaxelib(lib: String): Void {
		if (postHaxelibs.indexOf(lib) == -1) {
			postHaxelibs.push('-lib');
			postHaxelibs.push(lib);
		}
	}

	public function addFlag(flag: String): Void {
		if (flags.indexOf(flag) == -1) {
			flags.push('-D');
			flags.push(flag);
		}
	}

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new BuildConfigReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Build,
			command: [],
			haxeCompiler: 'haxe',
			hxml: null,
			runHxml: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: BuildConfig): Void {
		if (cfg.runHxml.length == 0) {
			var cmd = cfg.command.concat(haxelib);
			cmd = cmd.concat(flags).concat(postHaxelibs);
			if (cfg.app != null) {
				cmd.push('-D');
				cmd.push('app=${cfg.app}');
			}
			if (cfg.debug) {
				cmd.push('-debug');
			}
			if (cfg.hxml != null) {
				saveHxml(cfg.hxml, cmd);
			} else {
				runCompilation(cmd, cfg.debug, cfg.haxeCompiler);
			}
		}
		for (e in cfg.runHxml) {
			var cmd = cfg.command.copy();
			cmd = cmd.concat(flags).concat(postHaxelibs);
			cmd.push(e + '.hxml');
			if (cfg.app != null) {
				cmd.push('-D');
				cmd.push('app=${cfg.app}');
			}
			if (cfg.debug) {
				cmd.push('-debug');
			}
			runCompilation(cmd, cfg.debug, cfg.haxeCompiler);
		}
		checkCompilation();
	}

	private function saveHxml(name: String, commands: Array<String>): Void {
		name += '.hxml';
		var f: Bool = false;
		var s: String = '';
		for (e in commands) {
			s += e;
			s += f ? '\n' : ' ';
			f = !f;
		}
		var prev: String = FileSystem.exists(name) ? File.getContent(name) : null;
		if (prev != s) {
			if (FileSystem.exists(Uglify.CACHE_FILE)) FileSystem.deleteFile(Uglify.CACHE_FILE);
			File.saveContent(name, s);
		}
	}

	private function runCompilation(command: Array<String>, debug: Bool, compiler: String): Void {
		if (debug && server && compiler == 'haxe') {
			var newline = "\n";
			tryCounter = 3;
			var s: Socket = connectToHaxeServer();
			var d = Sys.getCwd();
			s.write('--cwd ' + d + newline);
			var cmd = command.join(newline);
			Sys.println(cmd);
			s.write(cmd);
			s.write("\000");

			var hasError = false;
			var r:String = null;
			try {
				r = s.read();
			} catch (e:Any) {
				compilationServerError(Std.string(e));
				return;
			}
			for (line in r.split(newline)) {
				switch (line.charCodeAt(0)) {
					case 0x01:
						Sys.println(line.substr(1).split("\x01").join(newline));
					case 0x02:
						hasError = true;
					default:
						Sys.stderr().writeString(line + newline);
				}
			}
			s.close();
			if (hasError) Sys.exit(1);
			lastCompilationOptions = {command:command, debug:debug, compiler:compiler};
		} else {
			Utils.command(compiler, command);
		}
	}

	private function connectToHaxeServer(): Socket {
		var port: Int = Std.parseInt(modules.xml.node.server.node.haxe.innerData);
		var s: Socket = null;
		while (true) try {
			s = new Socket();
			s.connect(new Host('127.0.0.1'), port);
			return s;
		} catch (e:Any) {
			compilationServerError(Std.string(e));
		}
		return null;
	}

	private function compilationServerError(s: String): Void {
		Sys.stderr().writeString(s);
		if (tryCounter-- <= 0) {
			Sys.exit(1);
		} else {
			Sys.println('');
			Sys.println('Connect error, try again after $TIMEOUT sec...');
			Sys.sleep(TIMEOUT);
			if (lastCompilationOptions != null) {
				var lco = lastCompilationOptions;
				lastCompilationOptions = null;
				runCompilation(lco.command, lco.debug, lco.compiler);
			}
		}
	}

	private function checkCompilation(): Void {
		if (lastCompilationOptions != null && lastCompilationOptions.debug && server && lastCompilationOptions.compiler == 'haxe') {
			var s = connectToHaxeServer();
			s.close();
		}
	}

}

private typedef BuildConfig = {
	> types.BAConfig,
	command: Array<String>,
	haxeCompiler: String,
	hxml: String,
	runHxml: Array<String>
}

private class BuildConfigReader extends BAReader<BuildConfig> {

	private static inline var UT: String = 'Unknown tag';

	override private function readNode(xml: Fast): Void {
		try {
			super.readNode(xml);
		} catch (s: String) {
			if (s.substr(0, UT.length) == UT) {
				switch xml.name {
					case 'hxml':
						cfg.runHxml.push(StringTools.trim(xml.innerData));
					case 'd':
						cfg.command.push('-D');
						if (xml.has.name)
							cfg.command.push(xml.att.name + '=' + xml.innerData);
						else
							cfg.command.push(xml.innerData);
					case 'i':
							cfg.command.push('--macro');
							cfg.command.push('"include(\'${xml.innerData}\')"');
					case a:
						cfg.command.push('-' + a);
						try {
							cfg.command.push(xml.innerData);
						} catch (_: Dynamic) {}
				}
			} else {
				throw s;
			}
		}
	}

	override private function clean(): Void {
		cfg.command = [];
		cfg.haxeCompiler = 'haxe';
		cfg.hxml = null;
		cfg.runHxml = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case 'haxe': cfg.haxeCompiler = val;
			case 'hxml': cfg.hxml = val;
			case _:
		}
	}

}