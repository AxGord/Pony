class Main extends pony.pixi.SimpleXmlApp {

	override private function init():Void {
		super.init();
		onLoaded < loadedHandler;
	}

	private function loadedHandler():Void {
		createUI();
	}

	private static function main():Void new Main();

}