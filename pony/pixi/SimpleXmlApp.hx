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

import pony.events.Signal0;
import pony.ui.AssetManager;

/**
 * Simple Xml Pixi.js Application
 * @author AxGord <axgord@gmail.com>
 */
@:ui('app.xml')
class SimpleXmlApp extends pony.ui.xml.PixiXmlUi {

	private var parentDomId:String;
	@:auto private var onLoaded:Signal0;

	public function new(?parentDomId:String) {
		super();
		this.parentDomId = parentDomId;
		pony.JsTools.disableContextMenuGlobal();
		pony.JsTools.onDocReady < init;
	}

	private function createApp():Void {
		app = new App(
			this,
			pony.Config.width,
			pony.Config.height,
			pony.Config.background,
			parentDomId == null ? null : js.Browser.document.getElementById(parentDomId)
		);
	}

	private function init():Void {
		createApp();
		AssetManager.loadComplete(SimpleXmlApp.loadUI, eLoaded.dispatch.bind(false));
	}

}