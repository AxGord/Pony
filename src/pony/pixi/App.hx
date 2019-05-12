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
import pony.geom.Rect;
import pony.magic.HasSignal;
import pony.time.DTimer;
import pony.time.JsDT;
import pony.time.Time;
import pony.ui.touch.pixi.Mouse;
import pony.ui.touch.pixi.Touch;
import pony.js.SmartCanvas;

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
class App extends SmartCanvas {

	/**
	 * First pixi app
	 */
	public static var main:App;
	
	/**
	 * Pixi Application
	 * Read-only
	 */
	public var app(default, null):pixi.core.Application;
	public var isWebGL(default, null):Bool;
	public var pauseDraw:Bool = false;
	public var container(default, null):Sprite;
	public var background(default, null):Int;
	public var sizeUpdate(default, set):Bool;
	private var ticker:Ticker;
	private var renderPause:Bool = false;
	private var backImgcontainer:Sprite;
	private var border:Graphics;
	
	/**
	 * @param	smallDeviceQuality - 1 ideal, 2 - low, 3 - normal, 4 - good
	 */
	public function new(
		container:Sprite,
		width: Int,
		height:Int,
		?bg:UInt,
		?parentDom:Element,
		smallDeviceQuality:SmallDeviceQuality = SmallDeviceQuality.normal,
		sizeUpdate:Bool = true,
		?backImg:Sprite,
		?ro:RenderOptions
	) {
		super(new Point(width, height), parentDom, smallDeviceQuality);
		background = bg;
		this.container = container;

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
		isWebGL = app.renderer.type == RendererType.WEBGL;

		if (backImg != null) {
			backImgcontainer = backImg;
			app.stage.addChild(backImgcontainer);
		}
		app.stage.addChild(container);
		initTouch();
		if (main == null) main = this;
		app.stop();
		app.ticker.stop();
		if (!JsDT.inited) JsDT.start();
		JsDT.onRender << render;
		this.sizeUpdate = sizeUpdate;
		#if stats addStats(); #end
	}

	private function set_sizeUpdate(b:Bool):Bool {
		if (b != sizeUpdate) {
			sizeUpdate = b;
			if (!renderPause) {
				if (b)
					onStageResize << stageResizeHandler;
				else
					onStageResize >> stageResizeHandler;
			}
		}
		return b;
	}

	@:extern private inline function initTouch():Void {
		if (!Mouse.inited) {
			Mouse.reg(container);
			Mouse.correction = correction;
		}
		if (!Touch.inited) {
			Touch.reg(container);
			Touch.correction = correction;
		}
	}

	public function drawBorders(?color:UInt):Void {
		border = new Graphics();
		border.beginFill(color == null ? background : color);
		var w:Int = stageInitSize.x * 2;
		var h:Int = stageInitSize.y * 2;
		border.drawRect(-w, -h, w, h * 3);
		border.drawRect(stageInitSize.x, -h, w, h * 3);
		border.drawRect(-w, -h, w * 3, h);
		border.drawRect(-w, stageInitSize.y, w * 3, h);
		container.addChild(border);
	}

	public inline function borderup():Void {
		container.addChild(border);
	}

	private function render():Void if (!renderPause) app.render();
	
	public function stageResizeHandler(ratio:Float, rect:Rect<Float>):Void {
		container.scale.set(ratio);
		container.x = rect.x;
		container.y = rect.y;
		app.renderer.resize(rect.width, rect.height);
		if (backImgcontainer != null) {
			backImgcontainer.width = rect.width / stageInitSize.x;
			backImgcontainer.height = rect.height / stageInitSize.y;
		}
	}
	
	private function correction(x:Float, y:Float):Point<Float> {
		return new Point((x - container.x) / container.width, (y - container.y) / container.height);
	}
	
	public function pauseRendering():Void {
		renderPause = true;
		if (sizeUpdate)
			onStageResize >> stageResizeHandler;
	}
	
	public function resumeRendering():Void {
		renderPause = false;
		if (sizeUpdate)
			onStageResize << stageResizeHandler;
	}

	#if stats
	@:auto public var onStats:Signal0;
	@:extern public inline function addStats():Void {
		var perf = new Perf();
		perf.addInfo(['UNKNOWN', 'WEBGL', 'CANVAS'][cast app.renderer.type]);
		var elements = [perf.fps, perf.info, perf.ms];
		if (perf.memory != null)
			elements.push(perf.memory);
			
		function change() {
			eStats.dispatch();
			for (e in elements) e.style.opacity = e.style.opacity != '0.1' ? '0.1' : '0.8';
		}
			
		for (e in elements) {
			#if !debug
			e.style.opacity = '0.1';
			#else
			e.style.opacity = '0.8';
			#end
			e.onclick = change;
		}
	}
	#end
	
}