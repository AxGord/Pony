package pony.pixi;

import js.Browser;
import js.html.Element;
import pixi.core.sprites.Sprite;
import pony.JsTools;
import pony.Config;

/**
 * Simple Pixi.js Application
 * @author AxGord <axgord@gmail.com>
 */
class SimpleApp extends Sprite {

	public var app: App;

	private var parentDomId: String;

	public function new(?parentDomId: String) {
		super();
		this.parentDomId = parentDomId;
		JsTools.disableContextMenuGlobal();
		JsTools.onDocReady < init;
	}

	private function init(): Void {
		var preloader: Element = Browser.document.getElementById('preloader');
		if (preloader != null) preloader.remove();
		app = new App(this, Config.width, Config.height, Config.background,
			parentDomId == null ? null : Browser.document.getElementById(parentDomId));
	}

}