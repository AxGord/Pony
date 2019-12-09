package pony.ui.touch.flash;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.Event;
import pony.time.DeltaTime;
import pony.ui.touch.Mouse;
import pony.ui.touch.TouchableBase;

/**
 * Flash TouchableMouse
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.TouchableBase)
class TouchableMouse {

	private static var inited: Bool = false;
	public static var down(default, null): Bool = false;

	public static function init(): Void {
		if (inited) return;
		inited = true;
		Mouse.onMove << TouchableBase.dispatchMove.bind(0);
		Mouse.onLeftDown << function() down = true;
		Mouse.onLeftUp << function() down = false;
		Mouse.onLeave << function() down = false;
	}

	private var obj: DisplayObject;
	private var base: TouchableBase;
	private var over: Bool = false;
	private var _down: Bool = false;
	private var overBeforeCheck: Bool;

	public function new(obj: DisplayObject, base: TouchableBase) {
		init();
		this.obj = obj;
		this.base = base;
		obj.addEventListener(MouseEvent.MOUSE_OVER, overHandler, false, 0, true);
		obj.addEventListener(MouseEvent.MOUSE_OUT, outHandler, false, 0, true);
		obj.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, 0, true);
		obj.addEventListener(MouseEvent.MOUSE_UP, upHandler, false, 0, true);
		obj.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler, false, 0, true);
		if (obj.stage != null)
			obj.stage.addEventListener(MouseEvent.MOUSE_UP, globUpHandler, false, 0, true);
		else
			obj.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, false, 0, true);
		Mouse.onLeave << leaveHandler;
	}

	private function addedToStageHandler(_): Void {
		obj.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		obj.stage.addEventListener(MouseEvent.MOUSE_UP, globUpHandler, false, 0, true);
	}

	public function destroy(): Void {
		leaveHandler();
		obj.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
		obj.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
		obj.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		obj.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		obj.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		if (obj.stage != null)
			obj.stage.removeEventListener(MouseEvent.MOUSE_UP, globUpHandler, false);
		else
			obj.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
		Mouse.onLeave >> leaveHandler;
		obj = null;
		base = null;
	}

	private function overHandler(_): Void {
		over = true;
		down ? base.dispatchOverDown() : base.dispatchOver();
	}

	private function outHandler(_): Void {
		over = false;
		down ? base.dispatchOutDown() : base.dispatchOut();
	}

	private function downHandler(e: MouseEvent): Void {
		_down = true;
		base.dispatchDown(0, e.stageX, e.stageY);
	}

	private function upHandler(_): Void {
		_down = false;
		if (!over) base.dispatchOutUp();
		else base.dispatchUp();
	}

	private function globUpHandler(_): Void {
		_down = false;
		if (!over) base.dispatchOutUp();
		else DeltaTime.fixedUpdate < up;
	}

	private function wheelHandler(e: MouseEvent): Void {
		base.eWheel.dispatch(e.delta);
	}

	private function up(): Void {
		if (!over) base.dispatchOutUp();
		else base.dispatchUp();
	}

	private function leaveHandler(): Void {
		if (over) {
			over = false;
			_down ? base.dispatchOutDown() : base.dispatchOut();
		}
		if (_down) {
			_down = false;
			base.dispatchOutUp();
		}
	}

}