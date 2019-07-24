package pony.ui.touch.heaps;

import js.html.MouseEvent;
import js.Browser;
import h2d.Drawable;
import h2d.Interactive;
import hxd.Event;
import pony.time.DeltaTime;
import pony.heaps.HeapsApp;
import pony.geom.Point;

/**
 * Touchable
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.Mouse)
class Touchable extends TouchableBase {

	private static var inited:Bool = false;

	public static var down(default, null):Bool = false;
	public static var downRight(default, null):Bool = false;
	private static inline var MOUSEMOVE:String = 'mousemove';
	private static inline var MOUSEUP:String = 'mouseup';
	private static inline var MOUSEDOWN:String = 'mousedown';
	private static inline var MOUSELEAVE:String = 'mouseout';
	private static inline var MOUSEENTER:String = 'mouseover';
	private static inline var TOUCHESTART:String = 'touchstart';
	private static inline var TOUCHEND:String = 'touchend';
	private static inline var TOUCHCANCEL:String = 'touchcancel';

	private static var lastPos: Point<Int> = new Point(0, 0);

	public static function init():Void {
		if (inited) return;
		inited = true;
		hxd.Window.getInstance().addEventTarget(globMouseMove);
	}

	@:access(h2d.Scene)
	private static function globMouseMove(event : hxd.Event):Void {
		switch event.kind {
			case EMove:
				if (HeapsApp.instance != null && HeapsApp.instance.s2d != null) {
					lastPos = new Point(
						HeapsApp.instance.s2d.screenXToLocal(event.relX),
						HeapsApp.instance.s2d.screenYToLocal(event.relY)
					);
					TouchableBase.dispatchMove(
						event.touchId == null ? 0 : event.touchId,
						lastPos.x,
						lastPos.y
					);
				}
			case EWheel:
				pony.ui.touch.Mouse.eWheel.dispatch(event.wheelDelta > 0 ? 1 : -1);
			case _:

		}
	}

	public var propagateOver: Bool = false;
	public var propagateOut: Bool = false;
	public var propagateDown: Bool = false;
	public var propagateUp: Bool = false;
	public var propagateWheel: Bool = false;
	private var interactive:Interactive;
	private var over:Bool = false;
	private var outover:Bool = false;
	private var _down:Null<Bool> = null;
	private var _downRight:Null<Bool> = null;
	private var wantUp:Bool = false;
	private var wantUpRight:Bool = false;
	
	public function new(interactive:Interactive) {
		init();
		super();
		this.interactive = interactive;
		interactive.onOver = overHandler;
		interactive.onOut = outHandler;
		interactive.onPush = downHandler;
		interactive.onRelease = upHandler;
		interactive.onWheel = wheelHandler;
		Browser.window.addEventListener(MOUSELEAVE, leaveHandler);
		Browser.window.addEventListener(MOUSEENTER, enterHandler);
		Browser.window.addEventListener(MOUSEUP, globMouseUpHandler);
		Browser.window.addEventListener(MOUSEDOWN, globMouseDownHandler);
		Browser.window.addEventListener(TOUCHESTART, globDownHandler);
		Browser.window.addEventListener(TOUCHEND, globUpHandler);
		Browser.window.addEventListener(TOUCHEND, leaveHandler);
		Browser.window.addEventListener(TOUCHCANCEL, leaveHandler);
	}

	override public function destroy():Void {
		super.destroy();
		leaveHandler();
		Browser.window.removeEventListener(MOUSELEAVE, leaveHandler);
		Browser.window.removeEventListener(MOUSEENTER, enterHandler);
		Browser.window.removeEventListener(MOUSEUP, globMouseUpHandler);
		Browser.window.removeEventListener(MOUSEDOWN, globMouseDownHandler);
		Browser.window.removeEventListener(TOUCHESTART, globDownHandler);
		Browser.window.removeEventListener(TOUCHEND, globUpHandler);
		Browser.window.removeEventListener(TOUCHEND, leaveHandler);
		Browser.window.removeEventListener(TOUCHCANCEL, leaveHandler);
		interactive.remove();
		interactive = null;
	}

	override private function addWheel(): Void {}
	override private function removeWheel(): Void {}

	private function wheelHandler(event: Event): Void {
		if (outover) return;
		eWheel.dispatch(event.wheelDelta > 0 ? 1 : -1);
		if (propagateWheel) event.propagate = true;
	}
	
	private function overHandler(event: Event):Void {
		if (outover) return;
		over = true;
		down ? dispatchOverDown(event.button == 1) : dispatchOver();
		if (propagateOver) event.propagate = true;
	}
	
	private function outHandler(event: Event):Void {
		if (outover) return;
		over = false;
		down ? dispatchOutDown(event.button == 1) : dispatchOut();
		if (propagateOut) event.propagate = true;
	}

	private function downHandler(event: Event): Void {
		if (outover || event.button > 1) return;
		if (!over) {
			over = true;
			dispatchOver();
		}
		var right:Bool = event.button == 1;
		if (right)
			_downRight = true;
		else
			_down = true;
		dispatchDown(0, lastPos.x, lastPos.y, right);
		if (propagateDown) event.propagate = true;
	}
	
	private function upHandler(event: Event): Void {
		if (outover || event.button > 1) return;
		var right:Bool = event.button == 1;
		if (right) {
			wantUpRight = true;
			_downRight = false;
		} else {
			wantUp = true;
			_down = false;
		}
		if (propagateUp) event.propagate = true;
		_globUpHandler(right);
	}

	private function globMouseUpHandler(event: MouseEvent):Void {
		if (event.button == 0)
			DeltaTime.fixedUpdate < globMouseUpLeftHandler;
		else if (event.button == 2)
			DeltaTime.fixedUpdate < globMouseUpRightHandler;
	}

	private function globMouseUpLeftHandler(): Void {
		if (wantUp)
			wantUp = false;
		else
			_globUpHandler(false);
	}

	private function globMouseUpRightHandler(): Void {
		if (wantUpRight)
			wantUpRight = false;
		else
			_globUpHandler(true);
	}

	private function globUpHandler():Void {
		DeltaTime.fixedUpdate < globMouseUpLeftHandler;
	}
	
	private function _globUpHandler(right:Bool):Void {
		if (right) {
			if (!over) {
				if (_downRight != null) dispatchOutUp(true);
			} else {
				if (_downRight != null) dispatchUp(true);
			}
			_downRight = null;
			downRight = false;
		} else {
			if (!over) {
				if (_down != null) dispatchOutUp();
			} else {
				if (_down != null) dispatchUp();
			}
			_down = null;
			down = false;
		}
	}

	private function globMouseDownHandler(event: MouseEvent):Void {
		if (event.button == 0)
			down = true;
		else if (event.button == 2)
			downRight = true;
	}

	private function globDownHandler():Void down = true;

	private function leaveHandler():Void {
		if (over) {
			outover = true;
			over = false;
			// _down ? dispatchOutDown() : dispatchOut();
		}
		// if (_down) {
		// 	_down = null;
		// 	dispatchOutUp();
		// }
		// if (_downRight) {
		// 	_downRight = null;
		// 	dispatchOutUp(true);
		// }
	}

	private function enterHandler():Void {
		if (outover) {
			outover = false;
			over = true;
			dispatchOver();
		}
	}
	
}