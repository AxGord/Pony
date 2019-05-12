package pony.pixi.ui;

import js.Browser;

/**
 * FSButtonCore
 * @author AxGord <axgord@gmail.com>
 */
class FSButtonCore {

	public function new() {
		App.main.element.addEventListener("fullscreenchange", setFullScreenImage);
		App.main.element.addEventListener("webkitfullscreenchange", setFullScreenImage);
		App.main.element.addEventListener("msfullscreenchange", setFullScreenImage);
		Browser.document.addEventListener("mozfullscreenchange", setFullScreenImage);
	}
	
	dynamic public function onEnable():Void {}
	dynamic public function onDisable():Void {}
	
	private function setFullScreenImage():Void {
		if (JsTools.isFSE)
			onEnable();
		else
			onDisable();
	}
	
	public function fsOn():Void App.main.fullscreen();
	
	public function fsOff():Void JsTools.closeFS();
	
}