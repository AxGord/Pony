package pony.pixi;

import pony.Config;
import pony.events.Signal0;
import pony.ui.AssetManager;
import pony.pixi.ui.SpinLoader;
import pixi.filters.extras.GlowFilter;

/**
 * Simple Xml Pixi.js Application
 * @author AxGord <axgord@gmail.com>
 */
@:ui('app.xml')
class SimpleXmlApp extends pony.ui.xml.PixiXmlUi {

	private var parentDomId:String;
	@:auto private var onLoaded:Signal0;
	private var preloader:SpinLoader;

	public function new(?parentDomId:String) {
		super();
		this.parentDomId = parentDomId;
		pony.JsTools.disableContextMenuGlobal();
		pony.JsTools.onDocReady < init;
	}

	private function createApp():Void {
		app = new App(
			this,
			Config.width,
			Config.height,
			Config.background,
			parentDomId == null ? null : js.Browser.document.getElementById(parentDomId)
		);
	}

	private function init():Void {
		createApp();
		var m:Int = Std.int(Math.min(Config.width, Config.height) / 20);
		preloader = new SpinLoader(m, Std.int(m / 10), Config.background.invert, 3, app);
		preloader.position.set(Config.width / 2, Config.height / 2);
		addChild(preloader);
		if (app.isWebGL && GlowFilter != null)
			preloader.filters = [new GlowFilter(16, 1.5, 0, Config.background.invert, 0.1)];
		preloader.core.percent = 0.1;
		SimpleXmlApp.loadUI(preloadProgressHandler);
		preloader.core.changePercent - 1 << preloadedHandler;
	}

	private function preloadProgressHandler(c:Int, t:Int):Void {
		preloader.core.initValue(0, t + 1);
		preloader.core.value = c + 1;
	}

	private function preloadedHandler():Void {
		removeChild(preloader);
		preloader.destroy(true);
		preloader = null;
		eLoaded.dispatch();
	}

}