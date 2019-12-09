package pony.heaps;

import h2d.Object;
import h2d.Graphics;
import hxd.SceneEvents.InteractiveScene;
import pony.color.UColor;
import h2d.Drawable;
import h2d.Scene;
import hxd.Window;
import pony.Config;
import pony.geom.Point;
import pony.geom.Rect;
import pony.js.SmartCanvas;
import pony.time.Time;
import pony.time.DTimer;
import pony.time.DeltaTime;
import pony.events.Signal0;
import js.html.Element;
import js.Browser;
import pony.magic.HasSignal;
import pony.magic.HasLink;
import hxd.App;

/**
 * HeapsApp
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety
class HeapsApp extends App implements HasSignal implements HasLink {

	public static var instance: Null<HeapsApp>;

	@:auto public var onInit: Signal0;
	public var noScale(link, link): Bool = canvas.noScale;
	public var sizeUpdate(default, set): Bool = false;
	private var renderPause: Bool = false;
	private var alignCenter: Bool = false;
	public var canvas: SmartCanvas;
	private var border: Null<Graphics>;

	public function new(?size: Point<Int>, ?color: UColor, ?parentDom: Element, sizeUpdate: Bool = true) {
		canvas = new SmartCanvas(size, parentDom);
		@:privateAccess Window.inst = new Window(canvas.canvas);
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
	}

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