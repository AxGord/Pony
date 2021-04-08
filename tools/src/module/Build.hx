package module;

import pony.Fast;
import pony.SPair;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import sys.net.Socket;
import sys.net.Host;
import haxe.io.Eof;

import types.BASection;
import module.Build.HAXE;
import module.Build.HXML;
import module.Build.D;

using pony.text.XmlTools;

private typedef LastCompilationOptions = {
	command: Array<SPair<String>>,
	debug: Bool,
	compiler: String
}

/**
 * Build module
 * @author AxGord <axgord@gmail.com>
 */
@:final class Build extends CfgModule<BuildConfig> {

	public static inline var HAXE: String = 'haxe';
	public static inline var HXML: String = 'hxml';
	public static inline var D: String = '-D';
	private static inline var PRIORITY: Int = 1;
	private static inline var TIMEOUT: Int = 5;
	private static inline var LIB: String = '-lib';

	private var flags(default, null): Array<String> = [];
	private var haxelib: Array<String>;
	private var hideWarningLibs: Array<String>;
	private var postHaxelibs: Array<String> = [];
	private var server: Bool = false;
	private var lastCompilationOptions: LastCompilationOptions;
	private var tryCounter: Int;

	public function new() super('build');

	override public function init(): Void {
		if (xml == null) return;
		haxelib = modules.xml.hasNode.haxelib ?
			[ for (e in modules.xml.node.haxelib.nodes.lib) if (!e.isTrue('mute')) e.innerData.split(' ').join(':') ] : [];
		hideWarningLibs = modules.xml.hasNode.haxelib ?
			[ for (e in modules.xml.node.haxelib.nodes.lib) if (e.isFalse('warning')) '/' + e.innerData.split(' ')[0] + '/' ] : [];
		server = modules.xml.hasNode.server && modules.xml.node.server.hasNode.haxe;
		initSections(PRIORITY, BASection.Build);
	}

	public inline function addHaxelib(lib: String): Void if (postHaxelibs.indexOf(lib) == -1) postHaxelibs.push(lib);
	public inline function addFlag(flag: String): Void if (flags.indexOf(flag) == -1) flags.push(flag);

	override private function readNodeConfig(xml: Fast, ac: AppCfg): Void {
		new BuildConfigReader(xml, {
			debug: ac.debug,
			app: ac.app,
			before: false,
			section: BASection.Build,
			command: [],
			haxeCompiler: HAXE,
			hxml: null,
			runHxml: [],
			allowCfg: true
		}, configHandler);
	}

	override private function runNode(cfg: BuildConfig): Void {
		if (cfg.runHxml.length == 0) {
			var cmd: Array<SPair<String>> = cfg.command.copy();
			for (l in haxelib) cmd.push(new SPair(LIB, l));
			for (d in flags) cmd.push(new SPair(D, d));
			for (l in postHaxelibs) cmd.push(new SPair(LIB, l));
			if (cfg.app != null) cmd.push(new SPair(D, 'app=${cfg.app}'));
			if (cfg.debug) cmd.push(new SPair('-debug', ''));
			if (cfg.hxml != null) {
				saveHxml(cfg.hxml, cmd);
			} else {
				runCompilation(cmd, cfg.debug, cfg.haxeCompiler);
			}
		} else for (e in cfg.runHxml) {
			var cmd: Array<SPair<String>> = cfg.command.copy();
			for (d in flags) cmd.push(new SPair(D, d));
			for (l in postHaxelibs) cmd.push(new SPair(LIB, l));
			cmd.push(new SPair(e + '.$HXML', ''));
			if (cfg.app != null) cmd.push(new SPair(D, 'app=${cfg.app}'));
			if (cfg.debug) cmd.push(new SPair('-debug', ''));
			runCompilation(cmd, cfg.debug, cfg.haxeCompiler);
		}
		checkCompilation();
	}

	private function saveHxml(name: String, commands: Array<SPair<String>>): Void {
		name += '.$HXML';
		var s: String = cmdArrPairToArrStr(commands).join('\n');
		var prev: String = FileSystem.exists(name) ? File.getContent(name) : null;
		if (prev != s) {
			if (FileSystem.exists(Uglify.CACHE_FILE)) FileSystem.deleteFile(Uglify.CACHE_FILE);
			File.saveContent(name, s);
		}
	}

	private function runCompilation(command: Array<SPair<String>>, debug: Bool, compiler: String): Void {
		var newline: String = '\n';
		if (debug && server && compiler == HAXE) {
			tryCounter = 3;
			var s: Socket = connectToHaxeServer();
			var d: String = Sys.getCwd();
			s.write('--cwd ' + d + newline);
			for (c in cmdArrPairToArrStr(command)) {
				Sys.print(c + ' ');
				s.write(c + newline);
			}
			Sys.println('');
			s.write('\000');
			var hasError: Bool = false;
			var r: String = null;
			try {
				r = s.read();
			} catch (e: Any) {
				compilationServerError(Std.string(e));
				return;
			}
			for (line in r.split(newline)) {
				switch (line.charCodeAt(0)) {
					case 0x01:
						Sys.println(StringTools.replace(line.substr(1), '\x01', ''));
					case 0x02:
						hasError = true;
					case null:
						break;
					default:
						if (!checkWarning(line)) Sys.stderr().writeString(line + newline);
				}
			}
			s.close();
			if (hasError) Utils.exit(1);
			lastCompilationOptions = { command: command, debug: debug, compiler: compiler };
		} else {
			var args: Array<String> = [];
			for (c in command) {
				args.push(c.a);
				if (c.b.length > 0) args.push(c.b);
			}
			Sys.println(compiler + ' ' + args.join(' '));
			var process: Process = new Process(compiler, args);
			var r: Int = process.exitCode();
			try {
				while (true) Sys.println(process.stdout.readLine());
			} catch (e: Eof) {}
			try {
				while (true) {
					var line: String = process.stderr.readLine();
					if (!checkWarning(line)) Sys.stderr().writeString(line + newline);
				}
			} catch (e: Eof) {}
			if (r > 0) error('$compiler error $r');
		}
	}

	private static inline function cmdPairToStr(p: SPair<String>): String return p.a + (p.b.length > 0 ? ' ' + p.b : '');
	private static inline function cmdArrPairToArrStr(a: Array<SPair<String>>): Array<String> return [ for (c in a) cmdPairToStr(c) ];

	private function connectToHaxeServer(): Socket {
		var port: Int = Std.parseInt(modules.xml.node.server.node.haxe.innerData);
		while (true) try {
			var s: Socket = new Socket();
			s.connect(new Host('127.0.0.1'), port);
			return s;
		} catch (e: Any) {
			compilationServerError(Std.string(e));
		}
		return null;
	}

	private function compilationServerError(s: String): Void {
		Sys.stderr().writeString(s);
		if (tryCounter-- <= 0) {
			Utils.exit(1);
		} else {
			Sys.println('');
			Sys.println('Connect error, try again after $TIMEOUT sec...');
			Sys.sleep(TIMEOUT);
			if (lastCompilationOptions != null) {
				var lco: LastCompilationOptions = lastCompilationOptions;
				lastCompilationOptions = null;
				runCompilation(lco.command, lco.debug, lco.compiler);
			}
		}
	}

	private function checkCompilation(): Void {
		if (lastCompilationOptions != null && lastCompilationOptions.debug && server && lastCompilationOptions.compiler == HAXE)
			connectToHaxeServer().close();
	}

	private function checkWarning(s: String): Bool {
		if (s.indexOf(': Warning :') != -1) for (lib in hideWarningLibs) if (s.indexOf(lib) != -1) return true;
		return false;
	}

}

private typedef BuildConfig = {
	> types.BAConfig,
	command: Array<SPair<String>>,
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
				var d: String = try {
					normalize(xml.innerData);
				} catch (_: Dynamic) {
					'';
				}
				switch xml.name {
					case HXML:
						cfg.runHxml.push(d);
					case 'd':
						cfg.command.push(new SPair(D, xml.has.name ? normalize(xml.att.name) + '=' + d : d));
					case 'm':
						cfg.command.push(new SPair('--macro', d));
					case 'i':
						cfg.command.push(new SPair('--macro', 'include(\'$d\')'));
					case 'k':
						cfg.command.push(new SPair('--macro', 'keep(\'$d\')'));
					case 'interp':
						cfg.command.push(new SPair('--interp', ''));
					case a:
						cfg.command.push(new SPair('-$a', d));
				}
			} else {
				throw s;
			}
		}
	}

	override private function clean(): Void {
		cfg.command = [];
		cfg.haxeCompiler = HAXE;
		cfg.hxml = null;
		cfg.runHxml = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case HAXE: cfg.haxeCompiler = val;
			case HXML: cfg.hxml = val;
			case _:
		}
	}

}