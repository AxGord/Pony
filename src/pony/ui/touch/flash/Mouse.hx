package pony.ui.touch.flash;

import flash.events.MouseEvent;
import flash.display.Stage;
import flash.Lib;
import pony.time.DeltaTime;
import pony.ui.touch.Mouse as M;
import pony.ui.touch.MouseButton;
import pony.flash.MultyStage;

/**
 * Flash Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Mouse {

	private static inline var INIT_PRIORITY: Int = -2;
	private static inline var EVENTS_PRIORITY: Int = -999;
	private static inline var LOCK_PRIORITY: Int = -1000;

	private static var enabled: Bool = true;

	@:extern public static inline function init(): Void {
		DeltaTime.fixedUpdate.once(initNow, INIT_PRIORITY);
	}

	public static function initNow(): Void {
		MultyStage.apply(listenStage, unlistenStage);
		disableStd();
	}

	private static function listenStage(stage: Stage): Void {
		stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false, EVENTS_PRIORITY, true);
		stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, EVENTS_PRIORITY, true);
		stage.addEventListener(MouseEvent.MOUSE_UP, upHandler, false, EVENTS_PRIORITY, true);
		stage.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler, false, EVENTS_PRIORITY, true);
	}

	private static function unlistenStage(stage: Stage): Void {
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false);
		stage.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler, false);
		stage.removeEventListener(MouseEvent.MOUSE_UP, upHandler, false);
		stage.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler, false);
	}

	private static function moveHandler(event: MouseEvent): Void {
		M.moveHandler(event.stageX, event.stageY);
		tlock(event);
	}

	private static function downHandler(event: MouseEvent): Void {
		if (M.checkDown(MouseButton.LEFT))
			M.downHandler(event.stageX, event.stageY, MouseButton.LEFT);
		tlock(event);
	}

	private static function upHandler(event: MouseEvent): Void {
		if (M.checkUp(MouseButton.LEFT))
			M.upHandler(event.stageX, event.stageY, MouseButton.LEFT);
		tlock(event);
	}

	private static function wheelHandler(event: MouseEvent): Void {
		@:privateAccess M.eWheel.dispatch(event.delta);
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
		Lib.current.stage.addEventListener(MouseEvent.CLICK, lock, true, LOCK_PRIORITY, true);
		Lib.current.stage.addEventListener(MouseEvent.DOUBLE_CLICK, lock, true, LOCK_PRIORITY, true);
		try {
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_CLICK, lock, true, LOCK_PRIORITY, true);
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, lock, true, LOCK_PRIORITY, true);
			Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, lock, true, LOCK_PRIORITY, true);
		} catch (_: Any) {}
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_OUT, lock, true, LOCK_PRIORITY, true);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_OVER, lock, true, LOCK_PRIORITY, true);
		try {
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_CLICK, lock, true, LOCK_PRIORITY, true);
		} catch (_: Any) {}
		try {
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, lock, true, LOCK_PRIORITY, true);
			Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, lock, true, LOCK_PRIORITY, true);
		} catch (_: Any) {}
		Lib.current.stage.addEventListener(MouseEvent.ROLL_OUT, lock, true, LOCK_PRIORITY, true);
		Lib.current.stage.addEventListener(MouseEvent.ROLL_OVER, lock, true, LOCK_PRIORITY, true);
	}

	private static function lock(event: MouseEvent): Void event.stopImmediatePropagation();
	@:extern private static inline function tlock(event: MouseEvent): Void if (!enabled) event.stopImmediatePropagation();

}