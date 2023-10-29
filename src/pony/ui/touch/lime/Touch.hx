package pony.ui.touch.lime;

#if js
import js.Browser;
import js.html.TouchEvent;
#end
import lime.app.Event;
import lime.ui.Touch as T;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

/**
 * Lime Touch
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class Touch implements Declarator implements HasSignal {

	@:auto public static var onMove: Signal1<T>;
	@:auto public static var onStart: Signal1<T>;
	@:auto public static var onEnd: Signal1<T>;
	@:auto public static var onCancle: Signal1<Int>;

	private static var tMove: Map<Int, T> = new Map<Int, T>();

	private static var startStack: Array<T> = [];
	private static var endStack: Array<T> = [];

	private static var moveEvent: Event<lime.ui.Touch -> Void>;
	private static var startEvent: Event<lime.ui.Touch -> Void>;
	private static var endEvent: Event<lime.ui.Touch -> Void>;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function init(): Void {
		DeltaTime.fixedUpdate.once(initNow, -2);
	}

	public static function initNow():Void {
		#if js
		eCancle.onTake << Browser.document.addEventListener.bind('touchcancel', handleTouchEvent);
		eCancle.onLost << Browser.document.removeEventListener.bind('touchcancel', handleTouchEvent);
		#end
		hackMove();
		hackDown();
		hackUp();
	}

	private static function hackMove(): Void {
		moveEvent = T.onMove;
		var event: Event<lime.ui.Touch -> Void> = new Event<lime.ui.Touch -> Void>();
		event.add(moveHandler, false, 1000);
		T.onMove = event;
	}

	private static function hackDown(): Void {
		startEvent = T.onStart;
		var event: Event<lime.ui.Touch -> Void> = new Event<lime.ui.Touch -> Void>();
		event.add(startHandler, false, 1000);
		T.onStart = event;
	}

	private static function hackUp(): Void {
		endEvent = T.onEnd;
		var event: Event<lime.ui.Touch -> Void> = new Event<lime.ui.Touch -> Void>();
		event.add(endHandler, false, 1000);
		T.onEnd = event;
	}

	public static function enableStd(): Void {
		onMove.add(moveEvent.dispatch, 1);
		onStart.add(startEvent.dispatch, 1);
		onEnd.add(endEvent.dispatch, 1);
	}

	public static function disableStd(): Void {
		onMove.remove(moveEvent.dispatch);
		startEvent.remove(startEvent.dispatch);
		endEvent.remove(endEvent.dispatch);
	}

	#if js
	private static function handleTouchEvent(event: TouchEvent): Void {
		for (t in event.changedTouches) eCancle.dispatch(t.identifier);
	}
	#end

	private static function moveHandler(t: T): Void {
		tMove[t.id] = t;
		DeltaTime.fixedUpdate.once(moveDispatch, -8);
	}

	private static function moveDispatch(): Void {
		for (t in tMove) eMove.dispatch(t);
		tMove = new Map();
	}

	private static function startHandler(t: T): Void {
		startStack.push(t);
		DeltaTime.fixedUpdate.once(startDispatch, -9);
	}

	private static function startDispatch(): Void {
		for (t in startStack) eStart.dispatch(t);
		startStack = [];
	}

	private static function endHandler(t: T): Void {
		endStack.push(t);
		DeltaTime.fixedUpdate.once(endDispatch, -7);
	}

	private static function endDispatch(): Void {
		for (t in endStack) eEnd.dispatch(t);
		endStack = [];
	}

}