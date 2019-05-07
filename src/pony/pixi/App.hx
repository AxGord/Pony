package pony.pixi;

import js.Browser;
import js.html.CanvasElement;
import js.html.Element;
import pixi.core.Application.ApplicationOptions;
import pixi.core.Pixi.RendererType;
import pixi.core.sprites.Sprite;
import pixi.core.ticker.Ticker;
import pixi.core.graphics.Graphics;
import pony.events.Signal0;
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

typedef RenderOptions = {
	?antialias: Bool,
	?forceFXAA: Bool,
	?roundPixels: Bool,
	?transparent: Bool,
	?forceCanvas: Bool,
	?clearBeforeRender: Bool
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
	@:auto public var onFrequentResize:Signal0;
	public var canvas(default, null):CanvasElement;
	
	public var container(default, null):Sprite;
	public var parentDom(default, null):Element;
	
	private var _width:Int;
	private var _height:Int;
	private var smallDeviceQuality:Float;
	private var smallDeviceQualityOffset:Float;
	private var resizeTimer:DTimer;
	private var resizeEventName:String;
	
	private var ticker:Ticker;
	
	public var width(default, null):Int;
	public var height(default, null):Int;
	public var background(default, null):Int;

	private var renderPause:Bool = false;
	
	private var backImgcontainer:Sprite;

	public var scale(default, null):Float;
	public var resolution(get, never):Point<Int>;

	private var border:Graphics;
	
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
		resizeEventName:String = 'resize',
		?backImg:Sprite,
		?ro:RenderOptions
	) {
		this.width = width;
		this.height = height;
		background = bg;
		this.resizeEventName = resizeEventName;

		this.parentDom = parentDom;
		this.smallDeviceQuality = smallDeviceQuality;
		smallDeviceQualityOffset = 1 - 1 / smallDeviceQuality;
		resizeTimer = DTimer.createFixedTimer(resizeInterval);
		resizeTimer.complete << resizeHandler;
		
		Browser.window.addEventListener('orientationchange', refreshSize, true);
		Browser.window.addEventListener('focus', refreshSize, true);
		registerResizeListener();
		_width = width;
		_height = height;
		this.container = container;

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
			roundPixels: true,
			#if forcecanvas
			forceCanvas: true
			#end
		};

		if (ro != null) {
			if (ro.antialias != null)
				renderingOptions.antialias = ro.antialias;
			if (ro.forceFXAA != null)
				renderingOptions.forceFXAA = ro.forceFXAA;
			if (ro.roundPixels != null)
				renderingOptions.roundPixels = ro.roundPixels;
			if (ro.transparent != null)
				renderingOptions.transparent = ro.transparent;
			if (ro.clearBeforeRender != null)
				renderingOptions.clearBeforeRender = ro.clearBeforeRender;
			#if !forcecanvas
			if (ro.forceCanvas != null)
				renderingOptions.forceCanvas = ro.forceCanvas;
			#end
		}

		app = new pixi.core.Application(renderingOptions);

		if (parentDom == null)
			this.parentDom = Browser.document.body;
		this.parentDom.appendChild(app.view);
		
		isWebGL = app.renderer.type == RendererType.WEBGL;

		if (backImg != null) {
			backImgcontainer = backImg;
			app.stage.addChild(backImgcontainer);
		}

		app.stage.addChild(container);
		if (!Mouse.inited) {
			Mouse.reg(container);
			Mouse.correction = correction;
		}

		if (!Touch.inited) {
			Touch.reg(container);
			Touch.correction = correction;
		}
		resizeHandler();
		if (main == null) main = this;
		
		app.stop();
		app.ticker.stop();
		
		if (!JsDT.inited) JsDT.start();
		JsDT.onRender << render;
		
		#if stats addStats(); #end
	}

	public function drawBorders(?color:UInt):Void {
		border = new Graphics();
		border.beginFill(color == null ? background : color);
		var w:Int = _width * 2;
		var h:Int = _height * 2;
		border.drawRect(-w, -h, w, h * 3);
		border.drawRect(_width, -h, w, h * 3);
		border.drawRect(-w, -h, w * 3, h);
		border.drawRect(-w, _height, w * 3, h);
		container.addChild(border);
	}

	public inline function borderup():Void {
		container.addChild(border);
	}
	
	@:extern private inline function get_resolution():Point<Int> return new Point(_width, _height);

	private function render():Void if (!renderPause) app.render();
	
	public function fullscreen():Void JsTools.fse(parentDom);
	
	public dynamic function ratioMod(ratio:Float):Float return ratio;
	
	public function resizeHandler():Void {

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
		container.scale.set(ratio);
		
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
		Browser.window.removeEventListener(resizeEventName, refreshSize, false);
	}
	
	public function resumeRendering():Void {
		renderPause = false;
		registerResizeListener();
		refreshSize();
	}

	@:extern inline private function registerResizeListener():Void {
		Browser.window.addEventListener(resizeEventName, refreshSize, false);
	}
	
	public function refreshSize(?_):Void {
		eFrequentResize.dispatch();
		resizeTimer.reset();
		resizeTimer.start();
	}
	
	#if stats
	@:auto public var onStats:Signal0;
	@:extern public inline function addStats():Void {
		var perf = new Perf();
		perf.addInfo(["UNKNOWN", "WEBGL", "CANVAS"][cast app.renderer.type]);
		var elements = [perf.fps, perf.info, perf.ms];
		if (perf.memory != null)
			elements.push(perf.memory);
			
		function change() {
			eStats.dispatch();
			for (e in elements) e.style.opacity = e.style.opacity != "0.1" ? "0.1" : "0.8";
		}
			
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