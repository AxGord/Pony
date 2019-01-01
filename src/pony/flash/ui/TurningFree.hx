package pony.flash.ui;
import flash.display.MovieClip;
import flash.geom.Point;
import pony.time.DeltaTime;
import pony.ui.touch.Touch;
import pony.ui.touch.Touchable;

/**
 * TurningFree
 * @author AxGord <axgord@gmail.com>
 */
class TurningFree extends Turning {
#if !starling
	@:stage public var button:Button;
	@:stage public var lmin:MovieClip;
	@:stage public var lmax:MovieClip;
	private var _zero:Point = new Point(0, 0);
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}
	
	private function init():Void {
		if (lmin != null) core.minAngle = lmin.rotation;
		if (lmax != null) core.maxAngle = lmax.rotation;
		core.currentAngle = handle.rotation;
		handle.mouseEnabled = false;
		var t = new Touchable(this);
		t.onDown << downHandler;
	}
	
	private function downHandler(t:Touch):Void {
		t.onMove << moveHandler;
	}
	
	private function moveHandler(t:Touch):Void {
		core.toPoint(new Point(t.x, t.y));
	}
#end
}