import sys.FileSystem;

/**
 * Install Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {

	private static function main(): Void {
		Config.init();
		if (!Config.INSTALL) tryRun(Config.ARGS);
		if (!Utils.nodeExists) Sys.println('Warning: nodejs not installed!');
		new PonyInstall();
	}

	private static function tryRun(args: Array<String>): Void {
		if (args.length > 1) {
			Sys.setCwd(args.pop());
			var runfile: String = Config.BIN + (Config.OS == Windows ? 'pony.exe' : 'pony');
			if (FileSystem.exists(runfile)) {
				Utils.exit(Sys.command(runfile, args));
			} else {
				Sys.println('Pony not compiled');
				Utils.exit(1);
			}
		}
	}

}