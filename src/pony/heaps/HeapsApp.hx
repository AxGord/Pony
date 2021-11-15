package pony.heaps;

import h2d.Drawable;
import h2d.Graphics;
import h2d.Object;
import h2d.Scene;

import haxe.Timer;

import hxd.App;
import hxd.SceneEvents.InteractiveScene;
import hxd.Window;

import pony.Config;
import pony.color.UColor;
import pony.events.Signal1;
import pony.geom.Point;
import pony.geom.Rect;
import pony.magic.HasLink;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.time.Time;
#if js
import js.html.Element;

import pony.js.SmartCanvas;#end

/**
 * HeapsApp
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class HeapsApp extends App implements HasSignal implements HasLink {

	public static var instance: Null<HeapsApp>;
	public static var s2dReady(get, never): Bool;

	@:auto public var onInit: Signal1<HeapsApp>;
	public var noScale(link, link): Bool = canvas.noScale;
	public var sizeUpdate(default, set): Bool = false;
	public var canvas: SmartCanvas;
	private var renderPause: Bool = false;
	private var alignCenter: Bool = false;
	private var border: Null<Graphics>;

	public function new(?size: Point<Int>, ?color: UColor, #if js ?parentDom: Element, #end sizeUpdate: Bool = true) {
		#if js
		canvas = new SmartCanvas(size, parentDom);
		@:privateAccess Window.inst = new Window(canvas.canvas);
		#else
		canvas = new SmartCanvas(size);
		onInit < sdlInitHandler;
		#end
		super();
		if (color != null) engine.backgroundColor = color;
		#if mobile
		@:privateAccess engine.window.window.displayMode = DisplayMode.Fullscreen;
		#end
		this.sizeUpdate = sizeUpdate;
		if (instance == null) instance = this;
	}

	override private function update(dt: Float): Void {
		DeltaTime.fixedValue = dt;
		DeltaTime.fixedDispatch();
	}

	#if hl

	private var lastTick: Float = Timer.stamp();

	override private function mainLoop(): Void {
		super.mainLoop();
		var sleepTime: Float = 1 / (hxd.Timer.wantedFPS * 1.05) - (Timer.stamp() - lastTick);
		if (sleepTime > 0) Sys.sleep(sleepTime);
		lastTick = Timer.stamp();
	}

	#elseif js

	private var skipNextFrame: Bool = false;

	override private function mainLoop(): Void {
		if (!skipNextFrame) {
			super.mainLoop();
			skipNextFrame = hxd.Timer.dt < 1 / hxd.Timer.wantedFPS;
		} else {
			skipNextFrame = false;
		}
	}

	#end

	override private function init(): Void eInit.dispatch(this);

	public inline function setScalableScene(?scene: Scene, alignCenter: Bool = true, disposePrevious: Bool = true): Void {
		noScale = false;
		this.alignCenter = alignCenter;
		if (scene == null) scene = new Scene();
		setScene(scene, disposePrevious);
	}

	public inline function setFixedScene(?scene: Scene, alignCenter: Bool = false, disposePrevious: Bool = true): Void {
		noScale = true;
		this.alignCenter = alignCenter;
		if (scene == null) scene = new Scene();
		setScene(scene, disposePrevious);
	}

	override public function setScene(scene: InteractiveScene, disposePrevious: Bool = true): Void {
		super.setScene(scene, disposePrevious);
		if (sizeUpdate) canvas.updateSize();
		#if !js
		windowResizeHandler();
		#end
	}

	#if !js

	private function sdlInitHandler(): Void {
		@:privateAccess engine.window.addResizeEvent(windowResizeHandler);
	}

	private function windowResizeHandler(): Void {
		@:privateAccess canvas.setSize(engine.window.window.width, engine.window.window.height);
	}

	#end

	private function set_sizeUpdate(b: Bool): Bool {
		if (b != sizeUpdate) {
			sizeUpdate = b;
			if (!renderPause) {
				if (b)
					canvas.onStageResize << stageResizeHandler;
				else
					canvas.onStageResize >> stageResizeHandler;
			}
		}
		return b;
	}

	public function drawBorders(?color: UInt): Void {
		final border: Graphics = new Graphics();
		this.border = border;
		border.beginFill(@:nullSafety(Off) (color == null) ? engine.backgroundColor : color);
		var w: Int = canvas.stageInitSize.x * 2;
		var h: Int = canvas.stageInitSize.y * 2;
		border.drawRect(-w, -h, w, h * 3);
		border.drawRect(canvas.stageInitSize.x, -h, w, h * 3);
		border.drawRect(-w, -h, w * 3, h);
		border.drawRect(-w, canvas.stageInitSize.y, w * 3, h);
		s2d.add(border, 100);
	}

	public function stageResizeHandler(ratio: Float, rect: Rect<Float>): Void {
		if (s2d != null) {
			s2d.scaleMode = ScaleMode.Stretch(Std.int(rect.width), Std.int(rect.height));
			if (alignCenter) s2d.setPosition(rect.x, rect.y);
		}
	}

	public inline function localToGlobal(obj: Object, ?pos: Point<Float>): Point<Float>
		return pos != null ? pos + obj.localToGlobal() - canvas.rect.start : obj.localToGlobal() - canvas.rect.start;

	public function globalToLocal(x: Float, y: Float): Point<Float>
		return new Point(
			@:privateAccess s2d.interactiveCamera.screenXToCamera(x, y) - canvas.rect.x,
			@:privateAccess s2d.interactiveCamera.screenYToCamera(x, y) - canvas.rect.y
		);

	private static inline function get_s2dReady(): Bool return instance != null && instance.s2d != null;

}