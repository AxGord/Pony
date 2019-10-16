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

	private static inline var INIT_PRIORITY: Int = -2;
	private static inline var EVENTS_PRIORITY: Int = -999;
	private static inline var LOCK_PRIORITY: Int = -1000;

	private static var enabled: Bool = true;

	private static var currentX(get, never): Float;
	private static var currentY(get, never): Float;
	
	@:extern public static inline function init(): Void {
		DeltaTime.fixedUpdate.once(initNow, INIT_PRIORITY);
	}

	@:extern private static inline function get_currentX(): Float return Lib.current.stage.mouseX;
	@:extern private static inline function get_currentY(): Float return Lib.current.stage.mouseY;
	
	public static function initNow(): Void {
		hackMove();
		hackDown();
		hackUp();
		disableStd();
	}
	
	@:extern private static inline function hackMove(): Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false, EVENTS_PRIORITY);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, true, EVENTS_PRIORITY);
	}
	
	private static function moveHandler(event: MouseEvent): Void {
		M.moveHandler(currentX, currentY);
		tlock(event);
	}
	
	@:extern private static inline function hackDown(): Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, EVENTS_PRIORITY);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, true, EVENTS_PRIORITY);
	}
	
	private static function downHandler(event: MouseEvent): Void {
		if (M.checkDown(MouseButton.LEFT))
			M.downHandler(currentX, currentY, MouseButton.LEFT);
		tlock(event);
	}
	
	@:extern private static inline function hackUp():Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler, false, EVENTS_PRIORITY);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler, true, EVENTS_PRIORITY);
	}
	
	private static function upHandler(event: MouseEvent): Void {
		if (M.checkUp(MouseButton.LEFT))
			M.upHandler(currentX, currentY, MouseButton.LEFT);
		tlock(event);
	}
	
	public static function enableStd(): Void {
		enabled = true;
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, lock, true);
		try {
			Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_CLICK, lock, true);
			Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, lock, true);
			Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, lock, true);
		} catch (_: Any) {}
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_OUT, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_OVER, lock, true);
		try {
			Lib.current.stage.removeEventListener(MouseEvent.RIGHT_CLICK, lock, true);
		} catch (_: Any) {}
		try {
			Lib.current.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, lock, true);
			Lib.current.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, lock, true);
		} catch (_: Any) {}
		Lib.current.stage.removeEventListener(MouseEvent.ROLL_OUT, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.ROLL_OVER, lock, true);
	}

	public static function disableStd():Void {
		enabled = false;
		Lib.current.stage.addEventListener(MouseEvent.CLICK, lock, true, LOCK_PRIORITY);
		Lib.current.stage.addEventListener(MouseEvent.DOUBLE_CLICK, lock, true, LOCK_PRIORITY);
		try {
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_CLICK, lock, true, LOCK_PRIORITY);
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, lock, true, LOCK_PRIORITY);
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, lock, true, LOCK_PRIORITY);
		} catch (_: Any) {}
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_OUT, lock, true, LOCK_PRIORITY);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_OVER, lock, true, LOCK_PRIORITY);
		try {
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_CLICK, lock, true, LOCK_PRIORITY);
		} catch (_: Any) {}
		try {
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, lock, true, LOCK_PRIORITY);
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, lock, true, LOCK_PRIORITY);
		} catch (_: Any) {}
		Lib.current.stage.addEventListener(MouseEvent.ROLL_OUT, lock, true, LOCK_PRIORITY);
		Lib.current.stage.addEventListener(MouseEvent.ROLL_OVER, lock, true, LOCK_PRIORITY);
	}

	private static function lock(event: MouseEvent): Void event.stopImmediatePropagation();
	@:extern private static inline function tlock(event: MouseEvent): Void if (!enabled) event.stopImmediatePropagation();
	
}