/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import js.Browser;
import js.Error;
import js.html.Element;
import js.html.Event;
import pixi.core.Pixi;
import pixi.core.sprites.Sprite;
import pixi.plugins.app.Application;
import pony.events.Signal0;
import pony.geom.Point;
import pony.magic.HasSignal;
import pony.time.DTimer;
import pony.time.DeltaTime;
import pony.time.Time;
import pony.ui.touch.pixi.Mouse;
import pony.ui.touch.pixi.Touch;

/**
 * App
 * @author AxGord <axgord@gmail.com>
 */
class App extends Application implements HasSignal {
	
	public static inline var DEFAULT_FPS:Int = 60;
	public static inline var DEFAULT_RESIZE_INTERVAL:Int = 200;
	
	public static var main:App;
	
	public var isWebGL:Bool;
	public var pauseDraw:Bool = false;
	
	@:auto public var onResizeSignal:Signal0;
	
	private var _width:Float;
	private var _height:Float;
	private var container:Sprite;
	private var parentDom:Element;
	private var smallDeviceQuality:Float;
	private var smallDeviceQualityOffset:Float;
	private var resizeTimer:DTimer;
	
	/**
	 * @param	smallDeviceQuality - 1 ideal, 2 - low, 3 - normal, 4 - good
	 */
	public function new(
		renderType:String = 'auto',
		container:Sprite,
		width:Float,
		height:Float,
		?bg:UInt,
		?parentDom:Element,
		smallDeviceQuality:Float = 3,
		fps:Int = DEFAULT_FPS,
		resizeInterval:Time = DEFAULT_RESIZE_INTERVAL
	) {
		super();
		this.parentDom = parentDom;
		this.smallDeviceQuality = smallDeviceQuality;
		smallDeviceQualityOffset = 1 - 1 / smallDeviceQuality;
		resizeTimer = DTimer.createFixedTimer(resizeInterval);
		resizeTimer.complete << resizeHandler;
		backgroundColor = bg;
		antialias = false;
		Browser.window.addEventListener('orientationchange', _onWindowResize, true);
		Browser.window.addEventListener('focus', _onWindowResize, true);
		Browser.window.onresize = _onWindowResize;
		autoResize = false;
		_width = width;
		_height = height;
		this.container = container;
		onUpdate = updateHandler;
		start(renderType, parentDom);
		app.ticker.speed = fps / DEFAULT_FPS;
		isWebGL = renderer.type == Pixi.RENDERER_TYPE.WEBGL;
		stage.addChild(container);
		Mouse.reg(container);
		Mouse.correction = correction;
		Touch.reg(container);
		Touch.correction = correction;
		resizeHandler();
		if (main == null) main = this;
	}
	
	public function fullscreen():Void JsTools.fse(canvas);
	
	private function resizeHandler():Void {
		if (parentDom == null || JsTools.isFSE) {
			width = Browser.window.innerWidth;
			height = Browser.window.innerHeight;
		} else {
			width = parentDom.clientWidth;
			height = parentDom.clientHeight;
		}
		
		var w = width / _width;
		var h = height / _height;
		var d:Float = w > h ? h : w;
		
		var ratio = smallDeviceQuality <= 1 ? 1 : smallDeviceQualityOffset + d / smallDeviceQuality;
		if (ratio > 1) ratio = 1;
		
		//Stealing all mobile device resources
		//if (!JsTools.isMobile)
		//ratio *= Browser.window.devicePixelRatio;
		
		renderer.resize(width / d * ratio, height / d * ratio);
		canvas.style.width = width + "px";
		canvas.style.height = height + "px";
		
		if (w > h) {
			container.x = (width / d - _width) / 2 * ratio;
			container.y = 0;
		} else {
			container.x = 0;
			container.y = (height / d - _height) / 2 * ratio;
		}
		container.width = ratio;
		container.height = ratio;
		
		eResizeSignal.dispatch();
	}
	
	private function updateHandler(_):Void {
		DeltaTime.fixedValue = app.ticker.elapsedMS / 1000;
		#if (debug && callstack)
		try {
			DeltaTime.fixedDispatch();
		} catch (e:Error) {
			pauseRendering();
			JsTools.remove(canvas);
			JsTools.remove(renderer.view);
			DeltaTime.fixedUpdate.clear();
			var pre = Browser.document.createPreElement();
			if (parentDom != null)
				parentDom.appendChild(pre);
			else
				Browser.document.body.appendChild(pre);
			pre.appendChild(Browser.document.createTextNode(Std.string(e) + '\n\n'));
			untyped StackTrace.fromError(e).then(function(stackframes:Array<Dynamic>){
				for (s in stackframes) pre.appendChild(Browser.document.createTextNode(s.toString() + '\n'));
			});
			throw e;
		} catch (e:Dynamic) {
			pauseRendering();
			canvas.remove();
			renderer.view.remove();
			DeltaTime.fixedUpdate.clear();
			var pre = Browser.document.createPreElement();
			if (parentDom != null)
				parentDom.appendChild(pre);
			else
				Browser.document.body.appendChild(pre);
			pre.appendChild(Browser.document.createTextNode(Std.string(e) + '\n\n'));
			untyped StackTrace.get().then(function(stackframes:Array<Dynamic>){
				for (s in stackframes) pre.appendChild(Browser.document.createTextNode(s.toString() + '\n'));
			});
			throw e;
		} 
		#else
		DeltaTime.fixedDispatch();
		#end
	}
	
	private function correction(x:Float, y:Float):Point<Float> {
		return new Point((x - container.x) / container.width, (y - container.y) / container.height);
	}
	
	override public function resumeRendering():Void {
		super.resumeRendering();
		Browser.window.onresize = _onWindowResize;
	}
	
	override function _onWindowResize(event:Event):Void refreshSize();
	
	@:extern public inline function refreshSize():Void {
		resizeTimer.reset();
		resizeTimer.start();
	}
	
}