package pony.ui.touch.lime;

import lime.app.Application;
import lime.app.Event;
import pony.time.DeltaTime;
import pony.ui.touch.Mouse as M;
import pony.ui.touch.MouseButton;

/**
 * Lime Mouse
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class Mouse {
	#if !notouch
	private static var moveEvent: Event<Float -> Float -> Void>;
	private static var downEvent: Event<Float -> Float -> lime.ui.MouseButton -> Void>;
	private static var upEvent: Event<Float -> Float -> Int -> Void>;
	#end

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function init(): Void {
		DeltaTime.fixedUpdate.once(initNow, -2);
	}

	@:access(pony.ui.touch.Mouse)
	public static function initNow(): Void {
		hackMove();
		hackDown();
		hackUp();
		Application.current.window.onLeave.add(M.eLeave.dispatch);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function hackMove(): Void {
		#if !notouch
		moveEvent = Application.current.window.onMouseMove;
		var event: Event<Float -> Float -> Void> = new Event<Float -> Float -> Void>();
		untyped Application.current.window.onMouseMove = event;
		#else
		var event: Event<Float -> Float -> Void> = Application.current.window.onMouseMove;
		#end
		event.add(M.moveHandler, false, 1000);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function hackDown(): Void {
		#if !notouch
		downEvent = Application.current.window.onMouseDown;
		var event: Event<Float -> Float -> lime.ui.MouseButton -> Void> = new Event<Float -> Float -> lime.ui.MouseButton -> Void>();
		untyped Application.current.window.onMouseDown = event;
		#else
		var event: Event<Float -> Float -> lime.ui.MouseButton -> Void> = Application.current.window.onMouseDown;
		#end
		event.add(M.downHandler, false, 1000);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function hackUp():Void {
		#if !notouch
		upEvent = Application.current.window.onMouseUp;
		var event :Event<Float -> Float -> Int -> Void> = new Event<Float -> Float -> Int -> Void>();
		untyped Application.current.window.onMouseUp = event;
		#else
		var event: Event<Float -> Float -> Int -> Void> = Application.current.window.onMouseUp;
		#end
		event.add(M.upHandler, false, 1000);
	}

	public static function enableStd(): Void {
		#if !notouch
		M.onMove.add(moveEvent.dispatch, 1);
		M.onLeftDown.add(leftDown, 1);
		M.onMiddleDown.add(middleDown, 1);
		M.onRightDown.add(rightDown, 1);
		M.onLeftUp.add(leftUp, 1);
		M.onMiddleUp.add(middleUp, 1);
		M.onRightUp.add(rightUp, 1);
		#end
	}

	public static function disableStd(): Void {
		#if !notouch
		M.onMove.remove(moveEvent.dispatch);
		M.onLeftDown.remove(leftDown);
		M.onMiddleDown.remove(middleDown);
		M.onRightDown.remove(rightDown);
		M.onLeftUp.remove(leftUp);
		M.onMiddleUp.remove(middleUp);
		M.onRightUp.remove(rightUp);
		#end
	}

	#if !notouch
	private static function leftDown(x: Float, y: Float): Void downEvent.dispatch(x, y, lime.ui.MouseButton.LEFT);
	private static function rightDown(x: Float, y: Float): Void downEvent.dispatch(x, y, lime.ui.MouseButton.RIGHT);
	private static function middleDown(x: Float, y: Float): Void downEvent.dispatch(x, y, lime.ui.MouseButton.MIDDLE);
	private static function leftUp(x: Float, y: Float): Void upEvent.dispatch(x, y, lime.ui.MouseButton.LEFT);
	private static function rightUp(x: Float, y: Float): Void upEvent.dispatch(x, y, lime.ui.MouseButton.RIGHT);
	private static function middleUp(x: Float, y: Float): Void upEvent.dispatch(x, y, lime.ui.MouseButton.MIDDLE);
	#end

}
