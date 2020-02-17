import js.Browser;
import h2d.Scene;
import pony.ui.xml.HeapsXmlUi;
import pony.ui.AssetManager;
import pony.heaps.HeapsApp;
import pony.geom.Point;
import pony.Config;
import pony.JsTools;

class Main extends Scene {

	private var app: HeapsApp;

	private function new(app: HeapsApp) {
		super();
		this.app = app;
		AssetManager.loadComplete(MainUI.loadUI, loadHandler);
	}

	private function loadHandler(): Void {
		Browser.document.getElementById('preloader').remove();
		new MainUI(this).createUI(app);
	}

	private static function main():Void {
		AssetManager.baseUrl = Config.baseUrl;
		JsTools.onDocReady < init;
	}

	private static function init(): Void new HeapsApp(new Point<Int>(Config.width, Config.height), Config.background).onInit < initHandler;
	private static function initHandler(application: HeapsApp): Void application.setScalableScene(new Main(application));

}

@:ui('ui/main.xml')
class MainUI extends HeapsXmlUi {}