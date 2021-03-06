package pony.ui.touch.openfl;

import openfl.display.DisplayObject;
import openfl.events.MouseEvent;
import openfl.Lib;
import pony.ui.touch.TouchableBase;

/**
 * OpenFL TouchableMouse
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

	public function new(obj: DisplayObject, base: TouchableBase) {
		init();
		this.obj = obj;
		this.base = base;
		obj.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
		obj.addEventListener(MouseEvent.MOUSE_OUT, outHandler);

		obj.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		obj.addEventListener(MouseEvent.MOUSE_UP, upHandler);

		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, globUpHandler, false);

		Mouse.onLeave << leaveHandler;
	}

	public function destroy(): Void {
		leaveHandler();
		obj.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
		obj.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
		obj.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		obj.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, globUpHandler, false);
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
		if (!over) {
			over = true;
			base.dispatchOver();
		}
		_down = true;
		base.dispatchDown(0, e.stageX, e.stageY);
	}

	private function upHandler(_): Void {
		_down = false;
		if (!over) return;
		base.dispatchUp();
	}

	private function globUpHandler(_): Void {
		_down = false;
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