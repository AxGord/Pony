import haxe.io.Eof;
import sys.io.Process;
import sys.FileSystem;

/**
 * PonyInstall
 * @author AxGord <axgord@gmail.com>
 */
class PonyInstall extends BaseInstall {

	public function new() super('Pony Command-Line Tools', !Config.INSTALL, true);

	override private function run(): Void {
		new VSCodePluginsInstall();
		new VSCodeInsidersPluginsInstall();
		new HaxelibInstall();
		compile();
		new NpmInstall();
		new UserpathInstall();
	}

	private inline function compile(): Void {
		log('Prepare for compile pony');
		if (FileSystem.exists(Config.BIN)) {
			Utils.beginColor(90);
			for (e in FileSystem.readDirectory(Config.BIN)) {
				if (e == 'testcert.p12') continue;
				var f: String = Config.BIN + e;
				if (FileSystem.isDirectory(f)) continue;
				log('Delete: $e');
				FileSystem.deleteFile(f);
			}
			Utils.endColor();
		}
		log('Compile pony');
		Utils.beginColor(90);
		var newline: String = '\n';
		var compiler: String = 'haxe';
		var args: Array<String> = ['--cwd', Config.SRC, 'build.hxml'];
		Sys.println(compiler + ' ' + args.join(' '));
		var r: Int = if (Config.OS == TargetOS.Windows) {
			Sys.command(compiler, args);
		} else {
			var process: Process = new Process(compiler, args);
			try {
				var inWarning: Bool = false;
				while (true) {
					var line: String = process.stderr.readLine();
					if (inWarning) {
						if (line == '' || line.charAt(0) == ' ')
							continue;
						else
							inWarning = false;
					}
					if (checkWarning(line))
						inWarning = true;
					else
						Sys.stderr().writeString(line + newline);
				}
			} catch (e: Eof) {}
			process.exitCode();
		}
		if (r > 0) {
			Utils.beginColor(31);
			throw '$compiler error $r';
		}
		Utils.beginColor(32);
		Sys.println('Compilation complete');
		Utils.endColor();
		FileSystem.deleteFile(Config.BIN + 'pony.n');
	}

	private function checkWarning(s: String): Bool {
		if (s.toUpperCase().indexOf('WARNING') != -1) for (lib in Config.settings.hideWarnings) if (s.indexOf(lib) != -1) return true;
		return false;
	}

}