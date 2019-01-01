package pony.ui.touch.flash;

import flash.events.TouchEvent;
import flash.Lib;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

typedef TO = {x:Float, y:Float, id:Int};

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Touch implements Declarator implements HasSignal {

	@:auto public static var onMove:Signal1<TO>;
	@:auto public static var onStart:Signal1<TO>;
	@:auto public static var onEnd:Signal1<TO>;
	
	private static var enabled:Bool = true;
	
	private static var tMove:Map<Int, TO> = new Map<Int, TO>();
	
	private static var startStack:Array<TO> = [];
	private static var endStack:Array<TO> = [];
	
	@:extern inline public static function init():Void {
		DeltaTime.fixedUpdate.once(initNow, -2);
	}
	
	public static function initNow():Void {
		hackMove();
		hackDown();
		hackUp();
		disableStd();
	}
	
	@:extern inline private static function hackMove():Void {
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, moveHandler, true, -1000);
	}
	
	@:extern inline private static function hackDown():Void {
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, startHandler, true, -1000);
	}
	
	@:extern inline private static function hackUp():Void {
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, endHandler, true, -1000);
	}
	
	public static function enableStd():Void {
		enabled = true;
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_OUT, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_OVER, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_ROLL_OVER, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_TAP, lock, true);
	}
	
	public static function disableStd():Void {
		enabled = false;
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_OUT, lock, true, -1000);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_OVER, lock, true, -1000);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_ROLL_OUT, lock, true, -1000);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_ROLL_OVER, lock, true, -1000);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_TAP, lock, true, -1000);
	}
	
	private static function moveHandler(e:TouchEvent):Void {
		tMove[e.touchPointID] = {x:e.stageX, y:e.stageY, id:e.touchPointID};
		DeltaTime.fixedUpdate.once(moveDispatch, -8);
		tlock(e);
	}
	
	private static function moveDispatch():Void {
		for (t in tMove) eMove.dispatch(t);
		tMove = new Map();
	}
	
	private static function startHandler(e:TouchEvent):Void {
		startStack.push({x:e.stageX, y:e.stageY, id:e.touchPointID});
		DeltaTime.fixedUpdate.once(startDispatch, -9);
		tlock(e);
	}
	
	private static function startDispatch():Void {
		for (t in startStack) eStart.dispatch(t);
		startStack = [];
	}
	
	private static function endHandler(e:TouchEvent):Void {
		endStack.push({x:e.stageX, y:e.stageY, id:e.touchPointID});
		DeltaTime.fixedUpdate.once(endDispatch, -7);
		tlock(e);
	}
	
	private static function endDispatch():Void {
		for (t in endStack) eEnd.dispatch(t);
		endStack = [];
	}
	
	private static function lock(event:TouchEvent):Void event.stopImmediatePropagation();
	@:extern inline private static function tlock(event:TouchEvent):Void if (!enabled) event.stopImmediatePropagation();
	
}