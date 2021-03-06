import hxd.res.DefaultFont;
import h2d.Font;
import h2d.Scene;
import h2d.Text;
import pony.ui.AssetManager;
import pony.heaps.HeapsApp;
import pony.geom.Point;
import pony.Config;

class Main extends Scene {

	private var app: HeapsApp;

	private function new(app: HeapsApp) {
		super();
		this.app = app;
		#if js
		js.Browser.document.getElementById('preloader').remove();
		#end
		var font: Font = DefaultFont.get().clone();
		font.resizeTo(200);
		new Text(font, this).text = 'Hello world!';
	}

	private static function main():Void {
		AssetManager.baseUrl = Config.baseUrl;
		#if js
			pony.JsTools.onDocReady < init;
		#else
			#if (app == 'win')
			hl.UI.closeConsole();
			#end
			inline init();
		#end
	}

	private static function init(): Void new HeapsApp(new Point<Int>(Config.width, Config.height), Config.background).onInit < initHandler;
	private static function initHandler(application: HeapsApp): Void application.setScalableScene(new Main(application));

}