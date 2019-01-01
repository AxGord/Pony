package pony.pixi;

/**
 * Simple Pixi.js Application
 * @author AxGord <axgord@gmail.com>
 */
class SimpleApp extends pixi.core.sprites.Sprite {

	public var app:App;
	private var parentDomId:String;

	public function new(?parentDomId:String) {
		super();
		this.parentDomId = parentDomId;
		pony.JsTools.disableContextMenuGlobal();
		pony.JsTools.onDocReady < init;
	}

	private function init():Void {
		app = new App(
			this,
			pony.Config.width,
			pony.Config.height,
			pony.Config.background,
			parentDomId == null ? null : js.Browser.document.getElementById(parentDomId)
		);
	}

}