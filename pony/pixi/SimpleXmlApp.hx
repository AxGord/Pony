/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
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