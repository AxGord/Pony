package pony.ui.touch.flash;

import flash.events.TouchEvent;
import flash.Lib;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

typedef TO = {
	x: Float,
	y: Float,
	id: Int
}

/**
 * Flash Touch
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class Touch implements Declarator implements HasSignal {

	private static inline var INIT_PRIORITY: Int = -2;
	private static inline var LOCK_PRIORITY: Int = -1000;
	private static inline var START_PRIORITY: Int = -9;
	private static inline var MOVE_PRIORITY: Int = -8;
	private static inline var END_PRIORITY: Int = -7;

	@:auto public static var onMove: Signal1<TO>;
	@:auto public static var onStart: Signal1<TO>;
	@:auto public static var onEnd: Signal1<TO>;

	private static var enabled: Bool = true;

	private static var tMove: Map<Int, TO> = new Map<Int, TO>();

	private static var startStack: Array<TO> = [];
	private static var endStack: Array<TO> = [];

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function init(): Void {
		DeltaTime.fixedUpdate.once(initNow, INIT_PRIORITY);
	}

	public static function initNow(): Void {
		hackMove();
		hackDown();
		hackUp();
		disableStd();
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function hackMove(): Void {
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, moveHandler, true, LOCK_PRIORITY, true);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function hackDown(): Void {
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, startHandler, true, LOCK_PRIORITY, true);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function hackUp(): Void {
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, endHandler, true, LOCK_PRIORITY, true);
	}

	public static function enableStd(): Void {
		enabled = true;
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_OUT, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_OVER, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_ROLL_OVER, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_TAP, lock, true);
	}

	public static function disableStd(): Void {
		enabled = false;
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_OUT, lock, true, LOCK_PRIORITY, true);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_OVER, lock, true, LOCK_PRIORITY, true);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_ROLL_OUT, lock, true, LOCK_PRIORITY, true);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_ROLL_OVER, lock, true, LOCK_PRIORITY, true);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_TAP, lock, true, LOCK_PRIORITY, true);
	}

	private static function moveHandler(e: TouchEvent): Void {
		tMove[e.touchPointID] = {x:e.stageX, y:e.stageY, id:e.touchPointID};
		DeltaTime.fixedUpdate.once(moveDispatch, MOVE_PRIORITY);
		tlock(e);
	}

	private static function moveDispatch(): Void {
		for (t in tMove) eMove.dispatch(t);
		tMove = new Map();
	}

	private static function startHandler(e: TouchEvent): Void {
		startStack.push({x:e.stageX, y:e.stageY, id:e.touchPointID});
		DeltaTime.fixedUpdate.once(startDispatch, START_PRIORITY);
		tlock(e);
	}

	private static function startDispatch(): Void {
		for (t in startStack) eStart.dispatch(t);
		startStack = [];
	}

	private static function endHandler(e: TouchEvent): Void {
		endStack.push({x:e.stageX, y:e.stageY, id:e.touchPointID});
		DeltaTime.fixedUpdate.once(endDispatch, END_PRIORITY);
		tlock(e);
	}

	private static function endDispatch(): Void {
		for (t in endStack) eEnd.dispatch(t);
		endStack = [];
	}

	private static function lock(event: TouchEvent): Void event.stopImmediatePropagation();

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function tlock(event: TouchEvent): Void if (!enabled) event.stopImmediatePropagation();

}