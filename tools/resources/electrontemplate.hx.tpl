import pony.Config;

class Application extends pony.electron.ElectronApplication {

	private static function main():Void new Application();

	#if (haxe_ver < 4.2) override #end
	private function createMainWindow():Void {
		mapCreateWindow(Config.window_default);
	}

}