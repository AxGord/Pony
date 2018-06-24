import pony.Config;

class Application extends pony.electron.ElectronApplication {

	private static function main():Void new Application();

	override private function createMainWindow():Void {
		mapCreateWindow(Config.window_default);
	}

}