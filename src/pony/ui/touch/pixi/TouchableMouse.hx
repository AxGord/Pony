package pony.ui.touch.pixi;

import pixi.core.display.Container;
import pixi.interaction.InteractionEvent;
import pony.ui.touch.Mouse;

/**
 * PixiJS TouchableMouse
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.TouchableBase)
class TouchableMouse {

	private static var inited: Bool = false;
	public static var down(default, null): Bool = false;

	public static function init(): Void {
		if (inited) return;
		inited = true;
		pony.ui.touch.pixi.Mouse.init();
		Mouse.onMove << TouchableBase.dispatchMove.bind(0);
		Mouse.onLeftDown << function() down = true;
		Mouse.onLeftUp << function() down = false;
		Mouse.onLeave << function() down = false;
	}

	private var obj: Container;
	private var base: TouchableBase;
	private var over: Bool = false;
	private var _down: Bool = false;

	public function new(obj: Container, base: TouchableBase) {
		init();
		this.obj = obj;
		this.base = base;
		obj.on('mouseover', overHandler);
		obj.on('mouseout', outHandler);
		obj.on('mousedown', downHandler);
		obj.on('mouseup', upHandler);
		Mouse.onLeftUp << globUpHandler;
		Mouse.onLeave << leaveHandler;
	}

	public function destroy(): Void {
		leaveHandler();
		obj.removeListener('mouseover', overHandler);
		obj.removeListener('mouseout', outHandler);
		obj.removeListener('mousedown', downHandler);
		obj.removeListener('mouseup', upHandler);
		Mouse.onLeftUp >> globUpHandler;
		Mouse.onLeave >> leaveHandler;
		obj = null;
		base = null;
	}

	private function overHandler(_): Void {
		over = true;
		down ? base.dispatchOverDown() :  base.dispatchOver();
	}

	private function outHandler(_): Void {
		over = false;
		down ? base.dispatchOutDown() :  base.dispatchOut();
	}

	private function downHandler(e: InteractionEvent): Void {
		if (untyped e.data.originalEvent.button != MouseButton.LEFT) return;
		if (!over) {
			over = true;
			base.dispatchOver();
		}
		_down = true;
		var p = pony.ui.touch.pixi.Mouse.correction(e.data.global.x, e.data.global.y);
		base.dispatchDown(0, p.x, p.y);
	}

	private function upHandler(e: InteractionEvent): Void {
		if (untyped e.data.originalEvent.button != MouseButton.LEFT) return;
		_down = false;
		if (!over) return;
		base.dispatchUp();
	}

	private function globUpHandler(): Void {
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