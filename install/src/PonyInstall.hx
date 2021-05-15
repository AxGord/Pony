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
		if (s.indexOf(': Warning :') != -1) for (lib in Config.settings.hideWarnings) if (s.indexOf(lib) != -1) return true;
		return false;
	}

}