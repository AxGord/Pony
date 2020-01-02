package pony.heaps;

import h2d.Object;
import h2d.Graphics;
import h2d.Drawable;
import h2d.Scene;
import hxd.SceneEvents.InteractiveScene;
import hxd.Window;
import hxd.App;
import pony.Config;
import pony.color.UColor;
import pony.geom.Point;
import pony.geom.Rect;
import pony.time.Time;
import pony.time.DTimer;
import pony.time.DeltaTime;
import pony.events.Signal0;
import pony.magic.HasSignal;
import pony.magic.HasLink;
#if js
import pony.js.SmartCanvas;
import js.html.Element;
#end

/**
 * HeapsApp
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety class HeapsApp extends App implements HasSignal implements HasLink {

	public static var instance: Null<HeapsApp>;

	@:auto public var onInit: Signal0;
	public var noScale(link, link): Bool = canvas.noScale;
	public var sizeUpdate(default, set): Bool = false;
	private var renderPause: Bool = false;
	private var alignCenter: Bool = false;
	public var canvas: SmartCanvas;
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
		if (color != null)
			engine.backgroundColor = color;
		this.sizeUpdate = sizeUpdate;
		if (instance == null) instance = this;
	}

	override private function update(dt: Float): Void {
		DeltaTime.fixedValue = dt;
		DeltaTime.fixedDispatch();
	}

	override private function init(): Void eInit.dispatch();

	public inline function setScalableScene(scene: Scene, alignCenter: Bool = true, disposePrevious: Bool = true): Void {
		noScale = false;
		this.alignCenter = alignCenter;
		setScene(scene, disposePrevious);
	}

	public inline function setFixedScene(scene: Scene, alignCenter: Bool = false, disposePrevious: Bool = true): Void {
		noScale = true;
		this.alignCenter = alignCenter;
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
		screenUpdate();
		@:privateAccess engine.window.addResizeEvent(windowResizeHandler);
	}

	private function windowResizeHandler(): Void {
		@:privateAccess canvas.setSize(engine.window.width, engine.window.height);
		DeltaTime.fixedUpdate < screenUpdate;
	}

	private function screenUpdate(): Void @:privateAccess engine.window.window.setPosition(engine.window.window.x, engine.window.window.y);

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
		border = new Graphics();
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
			if (alignCenter)
				s2d.setPosition(rect.x, rect.y);
		}
	}

	public inline function localToGlobal(obj: Object, ?pos: Point<Float>): Point<Float>
		return pos != null ? pos + obj.localToGlobal() - canvas.rect.startAsPoint() : obj.localToGlobal() - canvas.rect.startAsPoint();

}