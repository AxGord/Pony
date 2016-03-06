/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.pixi;

import haxe.Constraints.FlatEnum;
import js.Browser;
import js.html.Element;
import js.html.Event;
import pixi.core.Pixi;
import pixi.core.sprites.Sprite;
import pixi.plugins.app.Application;
import pony.geom.Point;
import pony.time.DeltaTime;
import pony.ui.touch.pixi.Mouse;
import pony.ui.touch.pixi.Touch;

/**
 * App
 * @author AxGord <axgord@gmail.com>
 */
class App extends Application {
	
	public var isWebGL:Bool;
	
	private var _width:Float;
	private var _height:Float;
	private var container:Sprite;
	private var prevTime:Float = 0;
	private var parentDom:Element;
	
	public function new(container:Sprite, width:Float, height:Float, ?bg:UInt, ?parentDom:Element) {
		super();
		this.parentDom = parentDom;
		roundPixels = true;
		backgroundColor = bg;
		antialias = false;
		pixelRatio = Browser.window.devicePixelRatio;
		_width = width;
		_height = height;
		this.container = container;
		onResize = resizeHandler;
		onUpdate = updateHandler;
		start(parentDom);
		isWebGL = renderer.type == Pixi.RENDERER_TYPE.WEBGL;
		stage.addChild(container);
		__onWindowResize();
		Mouse.reg(container);
		Mouse.correction = correction;
		Touch.reg(container);
		Touch.correction = correction;
	}
	
	private function resizeHandler():Void {
		var w = width / _width;
		var h = height / _height;
		var d:Float;
		if (w > h) {
			d = h;
			var nw = _width * d;
			container.x = (width - nw) / 2;
			container.y = 0;
		} else {
			d = w;
			var nh = _height * d;
			container.x = 0;
			container.y = (height - nh) / 2;
		}
		container.width = d;
		container.height = d;
	}
	
	private function updateHandler(time:Float):Void {
		DeltaTime.fixedValue = (time - prevTime) / 1000;
		prevTime = time;
		DeltaTime.fixedDispatch();
	}
	
	private function correction(x:Float, y:Float):Point<Float> {
		return new Point((x - container.x) / container.width, (y - container.y) / container.height);
	}
	
	override function _onWindowResize(event:Event) {
		DeltaTime.fixedUpdate < __onWindowResize;
	}
	
	private function __onWindowResize():Void {
		if (parentDom == null) {
			width = Browser.window.innerWidth;
			height = Browser.window.innerHeight;
		} else {
			width = parentDom.clientWidth;
			height = parentDom.clientHeight;
		}
		renderer.resize(width, height);
		canvas.style.width = width + "px";
		canvas.style.height = height + "px";

		if (onResize != null) onResize();
	}
	
}