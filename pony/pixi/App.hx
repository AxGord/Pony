/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import js.Browser;
import js.html.CanvasElement;
import js.html.Element;
import pixi.core.Application.ApplicationOptions;
import pixi.core.Pixi.RendererType;
import pixi.core.sprites.Sprite;
import pixi.core.ticker.Ticker;
import pony.events.Signal1;
import pony.geom.Point;
import pony.magic.HasSignal;
import pony.time.DTimer;
import pony.time.JsDT;
import pony.time.Time;
import pony.ui.touch.pixi.Mouse;
import pony.ui.touch.pixi.Touch;

@:enum abstract SmallDeviceQuality(Int) to Int {
	var ideal = 1;
	var low = 2;
	var normal = 3;
	var good = 4;
}

/**
 * App
 * @author AxGord <axgord@gmail.com>
 */
class App implements HasSignal {
	
	public static inline var DEFAULT_RESIZE_INTERVAL:Int = 200;
	
	public static var main:App;
	
	/**
	 * Pixi Application
	 * Read-only
	 */
	public var app(default, null):pixi.core.Application;
	
	public var isWebGL(default, null):Bool;
	public var pauseDraw:Bool = false;
	
	@:auto public var onResize:Signal1<Float>;
	public var canvas(default, null):CanvasElement;
	
	public var container(default, null):Sprite;
	public var parentDom(default, null):Element;
	
	private var _width:Float;
	private var _height:Float;
	private var smallDeviceQuality:Float;
	private var smallDeviceQualityOffset:Float;
	private var resizeTimer:DTimer;
	
	private var ticker:Ticker;
	
	private var width:Int;
	private var height:Int;
	private var background:Int;
	private var renderPause:Bool = false;
	
	private var backImgcontainer:Sprite;

	public var scale(default, null):Float;
	
	/**
	 * @param	smallDeviceQuality - 1 ideal, 2 - low, 3 - normal, 4 - good
	 */
	public function new(
		container:Sprite,
		width:Int,
		height:Int,
		?bg:UInt,
		?parentDom:Element,
		smallDeviceQuality:SmallDeviceQuality = SmallDeviceQuality.normal,
		resizeInterval:Time = DEFAULT_RESIZE_INTERVAL,
		?backImg:Sprite
	) {
		this.width = width;
		this.height = height;
		background = bg;

		this.parentDom = parentDom;
		this.smallDeviceQuality = smallDeviceQuality;
		smallDeviceQualityOffset = 1 - 1 / smallDeviceQuality;
		resizeTimer = DTimer.createFixedTimer(resizeInterval);
		resizeTimer.complete << resizeHandler;
		
		Browser.window.addEventListener('orientationchange', refreshSize, true);
		Browser.window.addEventListener('focus', refreshSize, true);
		Browser.window.onresize = refreshSize;
		_width = width;
		_height = height;
		this.container = container;
		
		//beign pixi init
		canvas = Browser.document.createCanvasElement();
		canvas.style.width = width + "px";
		canvas.style.height = height + "px";
		canvas.style.position = "static";

		var renderingOptions:ApplicationOptions = {
			width: width,
			height: height,
			view: canvas,
			backgroundColor: background,
			resolution: 1,
			antialias: false,
			forceFXAA: false,
			autoResize: false,
			transparent: false,
			clearBeforeRender: true,
			preserveDrawingBuffer: false,
			roundPixels: true
		};
		//end pixi init

		app = new pixi.core.Application(renderingOptions);

		if (parentDom == null)
			parentDom = Browser.document.body;
		parentDom.appendChild(app.view);
		
		isWebGL = app.renderer.type == RendererType.WEBGL;

		if (backImg != null) {
			backImgcontainer = backImg;
			app.stage.addChild(backImgcontainer);
		}

		app.stage.addChild(container);
		Mouse.reg(container);
		Mouse.correction = correction;
		Touch.reg(container);
		Touch.correction = correction;
		resizeHandler();
		if (main == null) main = this;
		
		app.stop();
		app.ticker.stop();
		
		JsDT.start();
		JsDT.render = render;
		
		#if stats addStats(); #end
	}
	
	private function render():Void if (!renderPause) app.render();
	
	public function fullscreen():Void JsTools.fse(parentDom);
	
	dynamic public function ratioMod(ratio:Float):Float return ratio;
	
	private function resizeHandler():Void {
		width = parentDom.clientWidth;
		height = parentDom.clientHeight;
		
		var w = width / _width;
		var h = height / _height;
		var d:Float = w > h ? h : w;
		
		var ratio = smallDeviceQuality <= 1 ? 1 : smallDeviceQualityOffset + d / smallDeviceQuality;
		if (ratio > 1) ratio = 1;
		
		ratio = ratioMod(ratio);

		app.renderer.resize(width / d * ratio, height / d * ratio);
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
		
		if (backImgcontainer != null) {
			backImgcontainer.width = (width / d * ratio) / _width;
			backImgcontainer.height = (height / d * ratio) / _height;
		}

		this.scale = d;
		eResize.dispatch(d);
	}
	
	private function correction(x:Float, y:Float):Point<Float> {
		return new Point((x - container.x) / container.width, (y - container.y) / container.height);
	}
	
	public function pauseRendering():Void {
		renderPause = true;
		Browser.window.onresize = null;
	}
	
	public function resumeRendering():Void {
		renderPause = false;
		Browser.window.onresize = refreshSize;
		refreshSize();
	}
	
	public function refreshSize(?_):Void {
		resizeTimer.reset();
		resizeTimer.start();
	}
	
	#if stats
	@:extern public inline function addStats():Void {
		var perf = new Perf();
		perf.addInfo(["UNKNOWN", "WEBGL", "CANVAS"][app.renderer.type.getIndex()]);
		var elements = [perf.fps, perf.info, perf.ms];
		if (perf.memory != null)
			elements.push(perf.memory);
			
		function change() for (e in elements) e.style.opacity = e.style.opacity != "0.1" ? "0.1" : "0.8";
			
		for (e in elements) {
			#if !debug
			e.style.opacity = "0.1";
			#else
			e.style.opacity = "0.8";
			#end
			e.onclick = change;
		}
	}
	#end
	
}