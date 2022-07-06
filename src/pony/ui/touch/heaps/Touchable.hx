package pony.ui.touch.heaps;

#if js
import js.html.MouseEvent;
import js.Browser;
#end
import h2d.Drawable;
import h2d.Interactive;
import hxd.Event;
import hxd.Window;
import pony.time.DeltaTime;
import pony.heaps.HeapsApp;
import pony.geom.Point;

/**
 * Heaps Touchable
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety
@:access(pony.ui.touch.Mouse)
class Touchable extends TouchableBase {

	private static var inited: Bool = false;

	public static var down(default, null): Bool = false;
	public static var downRight(default, null): Bool = false;
	private static var MOUSEMOVE: String = 'mousemove';
	private static var MOUSEUP: String = 'mouseup';
	private static var MOUSEDOWN: String = 'mousedown';
	private static var MOUSELEAVE: String = 'mouseout';
	private static var MOUSEENTER: String = 'mouseover';
	private static var TOUCHESTART: String = 'touchstart';
	private static var TOUCHEND: String = 'touchend';
	private static var TOUCHCANCEL: String = 'touchcancel';
	private static var CLICK: String = 'click';

	private static var lastPos: Point<Float> = new Point<Float>(0, 0);

	public static function init(): Void {
		if (inited) return;
		inited = true;
		Window.getInstance().addEventTarget(globMouseMove);
	}

	private static inline function setLastPos(event: Event): Void
		lastPos = @:nullSafety(Off) HeapsApp.instance.globalToLocal(event.relX, event.relY);

	private static function globMouseMove(event: Event): Void {
		if (HeapsApp.s2dReady) switch event.kind {
			case EPush:
				setLastPos(event);
			case EMove:
				setLastPos(event);
				TouchableBase.dispatchMove(getTouchId(event), lastPos.x, lastPos.y);
			case EWheel:
				Mouse.eWheel.dispatch(convertWheel(event));
			case _:
		}
	}

	private static inline function convertWheel(event: Event): Float return event.wheelDelta * #if js 1 #else -0.1 #end;

	private static inline function getTouchId(event: Event): UInt return #if js event.touchId == null ? 0 : #end event.touchId;

	public var propagateOver: Bool = false;
	public var propagateOut: Bool = false;
	public var propagateDown: Bool = false;
	public var propagateUp: Bool = false;
	public var propagateWheel: Bool = false;
	private var interactive: Interactive;
	private var over: Bool = false;
	private var outover: Bool = false;
	private var _down: Null<Bool> = null;
	private var _downRight: Null<Bool> = null;
	private var denyDown: Bool = false;
	private var denyUp: Bool = false;

	public function new(interactive: Interactive) {
		init();
		super();
		this.interactive = interactive;
		interactive.onOver = overHandler;
		interactive.onOut = outHandler;
		#if ios
			interactive.onPush = delayedDownHandler;
			interactive.onRelease = delayedUpHandler;
		#else
			interactive.onPush = downHandler;
			interactive.onRelease = upHandler;
		#end
		interactive.onWheel = wheelHandler;
		#if js
		Browser.window.addEventListener(MOUSELEAVE, leaveHandler);
		Browser.window.addEventListener(MOUSEENTER, enterHandler);
		Browser.window.addEventListener(MOUSEUP, globMouseUpHandler);
		Browser.window.addEventListener(MOUSEDOWN, globMouseDownHandler);
		Browser.window.addEventListener(TOUCHESTART, globDownHandler);
		Browser.window.addEventListener(TOUCHEND, globUpHandler);
		Browser.window.addEventListener(TOUCHCANCEL, leaveHandler);
		Browser.window.addEventListener(CLICK, globTapHandler);
		#else
		Window.getInstance().addEventTarget(instanceMouseHandler);
		#end
	}

	override public function destroy(): Void {
		super.destroy();
		leaveHandler();
		#if js
		Browser.window.removeEventListener(MOUSELEAVE, leaveHandler);
		Browser.window.removeEventListener(MOUSEENTER, enterHandler);
		Browser.window.removeEventListener(MOUSEUP, globMouseUpHandler);
		Browser.window.removeEventListener(MOUSEDOWN, globMouseDownHandler);
		Browser.window.removeEventListener(TOUCHESTART, globDownHandler);
		Browser.window.removeEventListener(TOUCHEND, globUpHandler);
		Browser.window.removeEventListener(TOUCHCANCEL, leaveHandler);
		Browser.window.removeEventListener(CLICK, globTapHandler);
		#else
		Window.getInstance().removeEventTarget(instanceMouseHandler);
		#end
		interactive.remove();
		@:nullSafety(Off) interactive = null;
	}

	override private function addWheel(): Void {}
	override private function removeWheel(): Void {}

	private function wheelHandler(event: Event): Void {
		if (outover) return;
		eWheel.dispatch(convertWheel(event));
		if (propagateWheel) event.propagate = true;
	}

	private function overHandler(event: Event): Void {
		if (outover) return;
		over = true;
		down ? dispatchOverDown(getTouchId(event), event.button == 1) : dispatchOver();
		if (propagateOver) event.propagate = true;
	}

	private function outHandler(event: Event): Void {
		if (outover) return;
		over = false;
		down ? dispatchOutDown(getTouchId(event), event.button == 1) : dispatchOut();
		if (propagateOut) event.propagate = true;
	}

	private function delayedDownHandler(event: Event): Void DeltaTime.fixedUpdate < downHandler.bind(event);

	private function downHandler(event: Event): Void {
		if (outover || event.button > 1) return;
		if (denyDown) {
			denyDown = false;
			upHandler(event);
			return;
		}
		if (!over) {
			over = true;
			dispatchOver(getTouchId(event));
		}
		var right: Bool = event.button == 1;
		if (right)
			_downRight = true;
		else
			_down = true;
		dispatchDown(getTouchId(event), lastPos.x, lastPos.y, right);
		if (propagateDown) event.propagate = true;
	}

	private function delayedUpHandler(event: Event): Void DeltaTime.fixedUpdate < upHandler.bind(event);

	private function upHandler(event: Event): Void {
		if (outover || event.button > 1) return;
		var right: Bool = event.button == 1;
		if (right) {
			_downRight = false;
		} else {
			_down = false;
		}
		if (propagateUp) event.propagate = true;
		_globUpHandler(getTouchId(event), right);
	}

	#if js
	private function globTapHandler(event: MouseEvent): Void {
		if (!denyUp && !down && _down != true && over) {
			_down = true;
			dispatchDown(0, lastPos.x, lastPos.y, false);
			_down = false;
			_globUpHandler(false);
			denyDown = true;
		}
		DeltaTime.fixedUpdate < unlockDown;
	}

	private function unlockDown(): Void {
		denyDown = false;
		globMouseUpLeftHandler();
	}

	private function globMouseUpHandler(event: MouseEvent): Void {
		if (event.button == 0)
			globMouseUpLeftHandler();
		else if (event.button == 2)
			globMouseUpRightHandler();
	}

	private function globMouseDownHandler(event: MouseEvent): Void {
		if (event.button == 0)
			down = true;
		else if (event.button == 2)
			downRight = true;
	}

	#else

	private function instanceMouseHandler(event: Event): Void {
		switch event.kind {
			case EOut: leaveHandler();
			case EOver: enterHandler();
			case ERelease: globMouseUpLeftHandler();
			case EPush: down = true;
			case _:
		}
	}

	#end

	private inline function globMouseUpLeftHandler(): Void _globUpHandler(false);
	private inline function globMouseUpRightHandler(): Void _globUpHandler(true);

	private function globUpHandler(): Void {
		globMouseUpLeftHandler();
		touchUp();
	}

	private function _globUpHandler(id: Int = 0, right: Bool): Void {
		denyUp = true;
		DeltaTime.fixedUpdate < unlockUp;
		if (right) {
			if (!over) {
				if (_downRight != null) dispatchOutUp(id, true);
			} else {
				dispatchUp(id, true);
			}
			_downRight = null;
			downRight = false;
		} else {
			if (!over) {
				if (_down != null) dispatchOutUp(id);
			} else {
				dispatchUp(id);
			}
			_down = null;
			down = false;
		}
	}

	private function unlockUp(): Void denyUp = false;

	private function globDownHandler(): Void down = true;

	private function leaveHandler(): Void {
		if (over) {
			outover = true;
			over = false;
		}
	}

	private function enterHandler(): Void {
		if (outover) {
			outover = false;
			over = true;
			dispatchOver();
		}
	}

	private function touchUp(): Void {
		if (over) {
			_down != null && _down ? dispatchOutDown() : dispatchOut();
			over = false;
		}
		if (_down != null && _down) {
			_down = null;
			dispatchOutUp();
		}
	}

}