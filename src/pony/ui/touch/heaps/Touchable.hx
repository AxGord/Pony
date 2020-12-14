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

	private static var lastPos: Point<Int> = new Point(0, 0);

	public static function init(): Void {
		if (inited) return;
		inited = true;
		Window.getInstance().addEventTarget(globMouseMove);
	}

	@:access(h2d.Scene)
	private static function globMouseMove(event: Event): Void {
		switch event.kind {
			case EMove:
				if (HeapsApp.instance != null && HeapsApp.instance.s2d != null) {
					lastPos = new Point(
						HeapsApp.instance.s2d.screenXToViewport(event.relX) + HeapsApp.instance.canvas.rect.x,
						HeapsApp.instance.s2d.screenYToViewport(event.relY) + HeapsApp.instance.canvas.rect.y
					);
					TouchableBase.dispatchMove(
						#if js event.touchId == null ? 0 : #end event.touchId,
						lastPos.x,
						lastPos.y
					);
				}
			case EWheel:
				Mouse.eWheel.dispatch(event.wheelDelta > 0 ? 1 : -1);
			case _:

		}
	}

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
	private var wantUp: Bool = false;
	private var wantUpRight: Bool = false;
	private var denyDown: Bool = false;
	private var denyUp: Bool = false;

	public function new(interactive: Interactive) {
		init();
		super();
		this.interactive = interactive;
		interactive.onOver = overHandler;
		interactive.onOut = outHandler;
		interactive.onPush = downHandler;
		#if !js
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
		#end
		interactive.remove();
		@:nullSafety(Off) interactive = null;
	}

	override private function addWheel(): Void {}
	override private function removeWheel(): Void {}

	private function wheelHandler(event: Event): Void {
		if (outover) return;
		eWheel.dispatch(event.wheelDelta);
		if (propagateWheel) event.propagate = true;
	}

	private function overHandler(event: Event): Void {
		if (outover) return;
		over = true;
		down ? dispatchOverDown(event.button == 1) : dispatchOver();
		if (propagateOver) event.propagate = true;
	}

	private function outHandler(event: Event): Void {
		if (outover) return;
		over = false;
		down ? dispatchOutDown(event.button == 1) : dispatchOut();
		if (propagateOut) event.propagate = true;
	}

	private function downHandler(event: Event): Void {
		if (outover || event.button > 1) return;
		if (denyDown) {
			denyDown = false;
			upHandler(event);
			return;
		}
		if (!over) {
			over = true;
			dispatchOver();
		}
		var right: Bool = event.button == 1;
		if (right)
			_downRight = true;
		else
			_down = true;
		dispatchDown(0, lastPos.x, lastPos.y, right);
		if (propagateDown) event.propagate = true;
	}

	private function upHandler(event: Event): Void {
		if (outover || event.button > 1) return;
		var right: Bool = event.button == 1;
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

	#if js
	private function globTapHandler(event: MouseEvent): Void {
		if (!denyUp && !down && _down != true && over) {
			_down = true;
			dispatchDown(0, lastPos.x, lastPos.y, false);
			wantUp = true;
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
	#end

	private inline function globMouseUpLeftHandler(): Void {
		if (wantUp)
			wantUp = false;
		else
			_globUpHandler(false);
	}

	private inline function globMouseUpRightHandler(): Void {
		if (wantUpRight)
			wantUpRight = false;
		else
			_globUpHandler(true);
	}

	private function globUpHandler(): Void {
		globMouseUpLeftHandler();
		touchUp();
	}

	private function _globUpHandler(right: Bool): Void {
		wantUp = true;
		denyUp = true;
		DeltaTime.fixedUpdate < unlockUp;
		if (right) {
			if (!over) {
				if (_downRight != null) dispatchOutUp(true);
			} else {
				dispatchUp(true);
			}
			_downRight = null;
			downRight = false;
		} else {
			if (!over) {
				if (_down != null) dispatchOutUp();
			} else {
				dispatchUp();
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