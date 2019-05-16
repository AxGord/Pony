package pony.heaps;

import h2d.Graphics;
import hxd.SceneEvents.InteractiveScene;
import pony.color.UColor;
import h2d.Drawable;
import h2d.Scene;
import hxd.Window;
import pony.Config;
import pony.geom.Point;
import pony.time.JsDT;
import pony.geom.Rect;
import pony.js.SmartCanvas;
import pony.time.Time;
import pony.time.DTimer;
import pony.events.Signal0;
import js.html.Element;
import js.Browser;
import pony.magic.HasSignal;
import hxd.App;

class HeapsApp extends App implements HasSignal {

	public static var instance:HeapsApp;

	@:auto public var onInit:Signal0;
	public var sizeUpdate(default, set):Bool = false;
	private var renderPause:Bool = false;
	public var canvas:SmartCanvas;
	private var border:Graphics;

	public function new(size:Point<Int>, ?color:UColor, ?parentDom:Element, sizeUpdate:Bool = true) {
		canvas = new SmartCanvas(size, parentDom);
		@:privateAccess Window.inst = new Window(canvas.canvas);
		super();
		if (color != null)
			engine.backgroundColor = color;
		JsDT.start();
		this.sizeUpdate = sizeUpdate;
		if (instance == null) instance = this;
	}

	override private function init():Void eInit.dispatch();

	override public function setScene(scene:InteractiveScene, disposePrevious:Bool = true):Void {
		super.setScene(scene, disposePrevious);
		if (sizeUpdate)
			stageResizeHandler(canvas.ratio, canvas.rect);
	}
	
	private function set_sizeUpdate(b:Bool):Bool {
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

	public function drawBorders(?color:UInt):Void {
		border = new Graphics(s2d);
		border.beginFill(color == null ? engine.backgroundColor : color);
		var w:Int = canvas.stageInitSize.x * 2;
		var h:Int = canvas.stageInitSize.y * 2;
		border.drawRect(-w, -h, w, h * 3);
		border.drawRect(canvas.stageInitSize.x, -h, w, h * 3);
		border.drawRect(-w, -h, w * 3, h);
		border.drawRect(-w, canvas.stageInitSize.y, w * 3, h);
	}

	public inline function borderup():Void s2d.addChild(border);

	public function stageResizeHandler(ratio:Float, rect:Rect<Float>):Void {
		if (s2d != null) {
			s2d.setFixedSize(Std.int(rect.width), Std.int(rect.height));
			s2d.setPosition(rect.x, rect.y);
		}
	}

}