class Main extends pony.pixi.SimpleXmlApp {

	override private function init():Void {
		onLoaded < loadedHandler;
		super.init();
	}

	private function loadedHandler():Void {
		createUI();
	}

	private static function main():Void new Main();

}