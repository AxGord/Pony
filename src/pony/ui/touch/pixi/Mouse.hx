package pony.ui.touch.pixi;

import js.Browser;
import pixi.core.display.Container;
import pixi.interaction.InteractionEvent;
import pony.geom.Point;
import pony.ui.touch.Mouse as M;

/**
 * PixiJS Mouse
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.Mouse)
class Mouse {

	private static var obj: Container;

	public static var inited(default, null): Bool = false;

	public static function reg(obj: Container): Void {
		if (Mouse.obj == null) {
			Mouse.obj = obj;
			if (inited) _init();
		}
	}

	public static function init(): Void {
		if (inited) return;
		inited = true;
		if (obj != null) _init();
	}

	public static function _init(): Void {
		regSub(obj);
		M.eWheel.onTake << Browser.document.addEventListener.bind('wheel', wheelHandler, false);
		M.eWheel.onLost << Browser.document.removeEventListener.bind('wheel', wheelHandler, false);
	}

	public static function regSub(obj: Container): Void {
		obj.interactive = true;
		obj.on('mousedown', downHandler);
		obj.on('mouseup', upHandler);
		M.eMove.onTake << function() obj.on('mousemove', moveHandler);
		M.eMove.onLost << function() obj.removeListener('mousemove', moveHandler);
		M.eLeave.onTake << function() obj.on('mouseupoutside', upoutsideHandler);
		M.eLeave.onLost << function() obj.removeListener('mouseupoutside', upoutsideHandler);
	}

	private static function wheelHandler(e: Dynamic): Void {
		if (e.wheelDelta == null)
			M.eWheel.dispatch(e.deltaY > 0 ? -120 : 120);
		else
			M.eWheel.dispatch(e.wheelDelta);
		e.returnValue = false;
		e.preventDefault();
	}

	private static function downHandler(e: InteractionEvent): Void {
		var p = correction(e.data.global.x, e.data.global.y);
		M.downHandler(p.x, p.y, untyped e.data.originalEvent.button);
	}

	private static function upHandler(e: InteractionEvent): Void {
		var p = correction(e.data.global.x, e.data.global.y);
		M.upHandler(p.x, p.y, untyped e.data.originalEvent.button);
	}

	private static function moveHandler(e: InteractionEvent): Void {
		var p = correction(e.data.global.x, e.data.global.y);
		M.moveHandler(p.x, p.y);
	}

	private static function upoutsideHandler(_): Void M.eLeave.dispatch();

	public static dynamic function correction(x: Float, y: Float): Point<Float> return new Point(x, y);

}