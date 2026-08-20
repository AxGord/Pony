package module;

import haxe.io.Eof;
import module.Build.D;
import module.Build.HAXE;
import module.Build.HXML;
import pony.Fast;
import pony.SPair;
import pony.text.TextTools;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;
import sys.net.Host;
import sys.net.Socket;
import types.BASection;

using StringTools;
using pony.text.XmlTools;

private typedef LastCompilationOptions = {
	command: Array<SPair<String>>,
	debug: Bool,
	compiler: String,
	winfix: Bool
}

/**
 * Build module
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
final class Build extends CfgModule<BuildConfig> {

	public static inline final HAXE: String = 'haxe';
	public static inline final HXML: String = 'hxml';
	public static inline final D: String = '-D';
	private static inline final PRIORITY: Int = 1;
	private static inline final TIMEOUT: Int = 5;
	private static inline final LIB: String = '-lib';

	private var flags(default, null): Array<String> = [];
	private var haxelib: Array<String>;
	private var hideWarningLibs: Array<String>;
	private final postHaxelibs: Array<String> = [];
	private var server: Bool = false;
	private var lastCompilationOptions: LastCompilationOptions;
	private var tryCounter: Int;

	public function new() super('build');

	#if (haxe_ver < 4.2) override #end
	public function init(): Void {
		if (xml == null) return;
		haxelib = modules.xml.hasNode.haxelib ? [for (e in modules.xml.node.haxelib.nodes.lib) if (!e.isTrue('mute')) StringTools.trim(
			e.innerData
		)
			.split(' ')
			.join(':')] : [];
		hideWarningLibs = modules.xml.hasNode.haxelib ? [for (e in modules.xml.node.haxelib.nodes.lib) if (e.isFalse('warning')) '/'
			+ StringTools.trim(e.innerData).split(' ')[0] + '/'] : [];
		server = modules.xml.hasNode.server && modules.xml.node.server.hasNode.haxe
			&& !TextTools.isTrue(Sys.getEnv('PONY_DISABLE_BUILD_SERVER'));
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
			winfix: false,
			hxml: null,
			runHxml: [],
			allowCfg: true,
			cordova: false
		}, configHandler);
	}

	override private function runNode(cfg: BuildConfig): Void {
		if (cfg.runHxml.length == 0) {
			var cmd: Array<SPair<String>> = [for (l in haxelib) new SPair(LIB, l)];
			for (d in flags) cmd.push(new SPair(D, d));
			for (l in postHaxelibs) cmd.push(new SPair(LIB, l));
			if (cfg.app != null) cmd.push(new SPair(D, 'app=${cfg.app}'));
			if (cfg.debug) cmd.push(new SPair('-debug', ''));
			cmd = cmd.concat(cfg.command);
			if (cfg.hxml != null) {
				saveHxml(cfg.hxml, cmd);
			} else {
				runCompilation(cmd, cfg.debug, cfg.haxeCompiler, cfg.winfix && Utils.isWindows);
			}
		} else
			for (e in cfg.runHxml) {
				var cmd: Array<SPair<String>> = [for (d in flags) new SPair(D, d)];
				for (l in postHaxelibs) cmd.push(new SPair(LIB, l));
				if (cfg.app != null) cmd.push(new SPair(D, 'app=${cfg.app}'));
				if (cfg.debug) cmd.push(new SPair('-debug', ''));
				cmd = cmd.concat(cfg.command);
				cmd.push(new SPair('$e.$HXML', ''));
				runCompilation(cmd, cfg.debug, cfg.haxeCompiler, cfg.winfix && Utils.isWindows);
			}
		checkCompilation();
	}

	private function saveHxml(name: String, commands: Array<SPair<String>>): Void {
		name += '.$HXML';
		final s: String = cmdArrPairToArrStr(commands).join('\n');
		final prev: String = FileSystem.exists(name) ? File.getContent(name) : null;
		if (prev == s) return;
		if (FileSystem.exists(Uglify.CACHE_FILE)) FileSystem.deleteFile(Uglify.CACHE_FILE);
		File.saveContent(name, s);
	}

	private function runCompilation(command: Array<SPair<String>>, debug: Bool, compiler: String, winfix: Bool): Void {
		final newline: String = '\n';
		var firstOutput: Bool = true;
		function writeError(line: String): Void {
			if (firstOutput) {
				firstOutput = false;
				Sys.stderr().writeString(newline);
			}
			Sys.stderr().writeString(line + newline);
		}
		if (debug && server && compiler == HAXE && !winfix) {
			try { // Fix compilation server error
				final tpf: String = '${Utils.libPath}src/pony/heaps/HeapsAssets.hx';
				log('Update $tpf');
				File.saveContent(tpf, File.getContent(tpf));
			} catch (e: Dynamic) {
				error('Update failed');
			}
			tryCounter = 3;
			final s: Socket = connectToHaxeServer();
			final d: String = Sys.getCwd();
			s.write('--cwd $d$newline');
			for (c in cmdArrPairToArrStr(command)) {
				Sys.print('$c ');
				s.write(c + newline);
			}
			Sys.println('');
			s.write('\000');
			var hasError: Bool = false;
			var r: String = null;
			try {
				r = s.read();
			} catch (e: Any) {
				compilationServerError('$e');
				return;
			}
			var inWarning: Bool = false;
			for (line in r.split(newline)) {
				switch (line.charCodeAt(0)) {
					case 0x01:
						writeError(StringTools.replace(line.substr(1), '\x01', ''));
					case 0x02:
						hasError = true;
					case null:
						if (!firstOutput && !inWarning) writeError('');
					case v:
						if (inWarning) {
							if (v == ' '.code) continue;
							inWarning = false;
						}
						if (checkWarning(line))
							inWarning = true;
						else
							writeError(line);
				}
			}
			s.close();
			if (hasError) Utils.exit(1);
			lastCompilationOptions = {
				command: command,
				debug: debug,
				compiler: compiler,
				winfix: winfix
			};
		} else {
			final args: Array<String> = [];
			for (c in command) {
				args.push(c.a);
				if (c.b.length > 0) args.push(c.b);
			}
			if (winfix) {
				Utils.command(compiler, args);
			} else {
				Sys.println('$compiler ${args.join(' ')}');
				final process: Process = new Process(compiler, args);
				try {
					var inWarning: Bool = false;
					while (true) {
						final line: String = process.stderr.readLine();
						if (inWarning) {
							if (line == '' || line.startsWith(' ')) continue;
							inWarning = false;
						}
						if (checkWarning(line))
							inWarning = true;
						else
							writeError(line);
					}
				} catch (e: Eof) {}
				final r: Int = process.exitCode();
				if (r > 0) error('$compiler error $r');
			}
		}
	}

	private static inline function cmdPairToStr(p: SPair<String>): String return p.a + (p.b.length > 0 ? ' ${p.b}' : '');

	private static inline function cmdArrPairToArrStr(a: Array<SPair<String>>): Array<String> return [for (c in a) cmdPairToStr(c)];

	private function connectToHaxeServer(): Socket {
		final port: Int = Std.parseInt(modules.xml.node.server.node.haxe.innerData);
		while (true) try {
			final s: Socket = new Socket();
			s.connect(new Host('127.0.0.1'), port);
			return s;
		} catch (e: Any) {
			compilationServerError('$e');
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
				final lco: LastCompilationOptions = lastCompilationOptions;
				lastCompilationOptions = null;
				runCompilation(lco.command, lco.debug, lco.compiler, lco.winfix);
			}
		}
	}

	private function checkCompilation(): Void {
		if (lastCompilationOptions != null && lastCompilationOptions.debug && server && lastCompilationOptions.compiler == HAXE)
			connectToHaxeServer().close();
	}

	private function checkWarning(s: String): Bool {
		if (s.toUpperCase().indexOf('WARNING') != -1) for (lib in hideWarningLibs) if (s.indexOf(lib) != -1) return true;
		return false;
	}

}

private typedef BuildConfig = {
	> types.BAConfig,
	command: Array<SPair<String>>,
	haxeCompiler: String,
	hxml: String,
	winfix: Bool,
	runHxml: Array<String>
}

private class BuildConfigReader extends BAReader<BuildConfig> {

	private static inline final UT: String = 'Unknown tag';

	override private function readNode(xml: Fast): Void {
		try {
			super.readNode(xml);
		} catch (s: String) {
			if (s.substr(0, UT.length) == UT) {
				final d: String = try {
					normalize(xml.innerData);
				} catch (_: Dynamic) {
					'';
				}
				switch xml.name {
					case HXML:
						cfg.runHxml.push(d);
					case 'd':
						cfg.command.push(new SPair(D, xml.has.name ? '${normalize(xml.att.name)}=$d' : d));
					case 'm':
						cfg.command.push(new SPair('--macro', d));
					case 'i':
						cfg.command.push(new SPair('--macro', 'include(\'$d\')'));
					case 'k':
						cfg.command.push(new SPair('--macro', 'keep(\'$d\')'));
					case 'r':
						cfg.command.push(new SPair('--run', d));
					case 'cmd':
						cfg.command.push(new SPair('--cmd', d));
					case 'interp':
						cfg.command.push(new SPair('--interp', ''));
					case 'remap':
						cfg.command.push(new SPair('--remap', d));
					case a:
						cfg.command.push(new SPair('-$a', d));
				}
			} else {
				throw s;
			}
		}
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver < 4.2) override #end
	private function clean(): Void {
		cfg.command = [];
		cfg.haxeCompiler = HAXE;
		cfg.hxml = null;
		cfg.runHxml = [];
	}

	override private function readAttr(name: String, val: String): Void {
		switch name {
			case HAXE:
				cfg.haxeCompiler = val;
			case HXML:
				cfg.hxml = val;
			case 'winfix':
				cfg.winfix = TextTools.isTrue(val);
			case _:
		}
	}

}
