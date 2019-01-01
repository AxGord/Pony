import sys.FileSystem;

/**
 * Install Pony Command-Line Tools
 * @author AxGord <axgord@gmail.com>
 */
class Main {
	
	static function main():Void {
		Config.init();
		if (!Config.INSTALL) tryRun(Config.ARGS);
		if (!Utils.nodeExists) Sys.println('Warning: nodejs not installed!');
		new PonyInstall();
	}

	static function tryRun(args:Array<String>):Void {
		if (args.length > 1) {
			Sys.setCwd(args.pop());
			var runfile = Config.BIN + (Config.OS == Windows ? 'pony.exe' : 'pony');
			if (FileSystem.exists(runfile)) {
				Sys.exit(Sys.command(runfile, args));
			} else  {
				Sys.println('Pony not compiled');
				Sys.exit(1);
			}
		}
	}

}