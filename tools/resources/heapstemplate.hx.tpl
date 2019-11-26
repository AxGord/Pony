import hxd.res.DefaultFont;
import h2d.Font;
import h2d.Scene;
import h2d.Text;
import pony.ui.AssetManager;
import pony.heaps.HeapsApp;
import pony.geom.Point;
import pony.Config;
import pony.JsTools;

class Main extends Scene {

	private static var app: HeapsApp;

	private function new() {
		super();
		var font: Font = DefaultFont.get().clone();
		font.resizeTo(200);
		new Text(font, this).text = 'Hello world!';
	}

	private static function main():Void {
		AssetManager.baseUrl = Config.baseUrl;
		JsTools.onDocReady < init;
	}

	private static function init(): Void {
		app = new HeapsApp(new Point<Int>(Config.width, Config.height), Config.background);
		app.onInit < initHandler;
	}

	private static function initHandler(): Void app.setScalableScene(new Main());

}