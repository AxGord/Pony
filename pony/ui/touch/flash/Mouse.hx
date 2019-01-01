package pony.ui.touch.flash;

import flash.events.MouseEvent;
import flash.Lib;
import pony.time.DeltaTime;
import pony.ui.touch.Mouse as M;
import pony.ui.touch.MouseButton;

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Mouse {

	private static var enabled:Bool = true;

	private static var currentX(get, never):Float;
	private static var currentY(get, never):Float;
	
	@:extern inline public static function init():Void {
		DeltaTime.fixedUpdate.once(initNow, -2);
	}

	@:extern private static inline function get_currentX():Float return Lib.current.stage.mouseX;
	@:extern private static inline function get_currentY():Float return Lib.current.stage.mouseY;
	
	public static function initNow():Void {
		hackMove();
		hackDown();
		hackUp();
		disableStd();
	}
	
	@:extern inline private static function hackMove():Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false, -999);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, true, -999);
	}
	
	private static function moveHandler(event:MouseEvent):Void {
		M.moveHandler(currentX, currentY);
		tlock(event);
	}
	
	@:extern inline private static function hackDown():Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, -999);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, true, -999);
	}
	
	private static function downHandler(event:MouseEvent):Void {
		if (M.checkDown(MouseButton.LEFT))
			M.downHandler(currentX, currentY, MouseButton.LEFT);
		tlock(event);
	}
	
	@:extern inline private static function hackUp():Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler, false, -999);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler, true, -999);
	}
	
	private static function upHandler(event:MouseEvent):Void {
		if (M.checkUp(MouseButton.LEFT))
			M.upHandler(currentX, currentY, MouseButton.LEFT);
		tlock(event);
	}
	
	public static function enableStd():Void {
		enabled = true;
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, lock, true);
		try {
			Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_CLICK, lock, true);
			Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, lock, true);
			Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, lock, true);
		} catch (_:Any) {}
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_OUT, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_OVER, lock, true);
		try {
			Lib.current.stage.removeEventListener(MouseEvent.RIGHT_CLICK, lock, true);
		} catch (_:Any) {}
		try {
			Lib.current.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, lock, true);
			Lib.current.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, lock, true);
		} catch (_:Any) {}
		Lib.current.stage.removeEventListener(MouseEvent.ROLL_OUT, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.ROLL_OVER, lock, true);
	}
	public static function disableStd():Void {
		enabled = false;
		Lib.current.stage.addEventListener(MouseEvent.CLICK, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.DOUBLE_CLICK, lock, true, -1000);
		try {
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_CLICK, lock, true, -1000);
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, lock, true, -1000);
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, lock, true, -1000);
		} catch (_:Any) {}
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_OUT, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_OVER, lock, true, -1000);
		try {
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_CLICK, lock, true, -1000);
		} catch (_:Any) {}
		try {
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, lock, true, -1000);
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, lock, true, -1000);
		} catch (_:Any) {}
		Lib.current.stage.addEventListener(MouseEvent.ROLL_OUT, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.ROLL_OVER, lock, true, -1000);
	}

	private static function lock(event:MouseEvent):Void event.stopImmediatePropagation();
	@:extern inline private static function tlock(event:MouseEvent):Void if (!enabled) event.stopImmediatePropagation();
	
}