package pony.pixi;

import js.Browser;
import js.html.Element;
import pixi.filters.extras.GlowFilter;
import pony.Config;
import pony.JsTools;
import pony.events.Signal0;
import pony.pixi.ui.SpinLoader;
import pony.ui.AssetManager;
import pony.ui.xml.PixiXmlUi;

/**
 * Simple Xml Pixi.js Application
 * @author AxGord <axgord@gmail.com>
 */
@:ui('app.xml')
class SimpleXmlApp extends PixiXmlUi {

	@:auto private var onLoaded: Signal0;
	private final parentDomId: String;
	private var preloader: SpinLoader;
	private var momentalLoad: Bool = false;

	private static final assetsForLoadPath: String = '';

	private final assetsForLoad: Array<String> = null;

	public function new(?parentDomId: String) {
		super();
		this.parentDomId = parentDomId;
		JsTools.disableContextMenuGlobal();
		JsTools.onDocReady < init;
	}

	private function createApp(): Void {
		app = new App(
			this, Config.width, Config.height, Config.background, parentDomId == null ? null : Browser.document.getElementById(parentDomId)
		);
	}

	private function init(): Void {
		final dpreloader: Element = Browser.document.getElementById('preloader');
		if (dpreloader != null) dpreloader.remove();
		createApp();
		if (assetsForLoad == null) {
			loadUI(preloadProgressHandler);
		} else {
			final pair: Pair<Int -> Int -> Void, Int -> Int -> Void> = AssetManager.cbjoin(preloadProgressHandler);
			loadUI(pair.a);
			AssetManager.load(assetsForLoadPath, assetsForLoad, pair.b);
		}
		if (momentalLoad) {
			eLoaded.dispatch();
		} else {
			final m: Int = Std.int(Math.min(Config.width, Config.height) / 20);
			preloader = new SpinLoader(m, Std.int(m / 10), Config.background.invert, 3, app);
			preloader.position.set(Config.width / 2, Config.height / 2);
			addChild(preloader);
			if (app.isWebGL && GlowFilter != null) preloader.filters = [new GlowFilter(16, 1.5, 0, Config.background.invert, 0.1)];
			preloader.core.percent = 0.1;
			preloader.core.changePercent - 1 << preloadedHandler;
		}
	}

	private function preloadProgressHandler(c: Int, t: Int): Void {
		if (t == 0) {
			momentalLoad = true;
		} else if (preloader != null) {
			preloader.core.initValue(0, t + 1);
			preloader.core.value = c + 1;
		}
	}

	private function preloadedHandler(): Void {
		removeChild(preloader);
		preloader.destroy(true);
		preloader = null;
		eLoaded.dispatch();
	}

}
