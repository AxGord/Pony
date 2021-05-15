import sys.FileSystem;

/**
 * Install Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {

	private static function main(): Void {
		Config.init();
		if (!Config.INSTALL) tryRun(Config.ARGS);
		if (!Utils.nodeExists) {
			Utils.beginColor(31);
			Sys.println('Warning: nodejs not installed!');
			Utils.endColor();
		}
		new PonyInstall();
	}

	private static function tryRun(args: Array<String>): Void {
		if (args.length > 1) {
			Sys.setCwd(args.pop());
			var runfile: String = Config.BIN + (Config.OS == Windows ? 'pony.exe' : 'pony');
			if (FileSystem.exists(runfile)) {
				Utils.exit(Sys.command(runfile, args));
			} else {
				Utils.beginColor(31);
				Sys.println('Pony not compiled');
				Utils.endColor();
				Utils.exit(1);
			}
		}
	}

}