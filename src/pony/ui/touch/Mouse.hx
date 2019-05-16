package pony.ui.touch;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.Tools.ArrayTools;

private typedef MouseEvent = {x:Float, y:Float, b:MouseButton};

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Mouse implements Declarator implements HasSignal {

	@:auto public static var onMove:Signal2<Float, Float>;
	@:auto public static var onLeftDown:Signal2<Float, Float>;
	@:auto public static var onLeftUp:Signal2<Float, Float>;
	@:auto public static var onRightDown:Signal2<Float, Float>;
	@:auto public static var onRightUp:Signal2<Float, Float>;
	@:auto public static var onMiddleDown:Signal2<Float, Float>;
	@:auto public static var onMiddleUp:Signal2<Float, Float>;
	@:auto public static var onLeave:Signal0;
	@:auto public static var onWheel:Signal1<Int>;
	
	public static var x(default, null):Float;
	public static var y(default, null):Float;
	public static var actualX(default, null):Float;
	public static var actualy(default, null):Float;
	
	private static var downStack:Array<MouseEvent> = [];
	private static var upStack:Array<Int> = [];
	
	#if pixijs
	inline public static function init():Void pony.ui.touch.pixi.Mouse.init();
	#elseif flash
	inline public static function init():Void pony.ui.touch.flash.Mouse.init();
	inline public static function enableStd():Void pony.ui.touch.flash.Mouse.enableStd();
	inline public static function disableStd():Void pony.ui.touch.flash.Mouse.disableStd();
	#elseif lime
	inline public static function init():Void pony.ui.touch.lime.Mouse.init();
	inline public static function enableStd():Void pony.ui.touch.lime.Mouse.enableStd();
	inline public static function disableStd():Void pony.ui.touch.lime.Mouse.disableStd();
	#end
	
	public static function moveHandler(x:Float, y:Float):Void {
		Mouse.x = x;
		Mouse.y = y;
		DeltaTime.fixedUpdate.once(moveDispatch, -4);
	}
	
	private static function moveDispatch():Void {
		eMove.dispatch(x, y);
	}
	
	public static function downHandler(x:Float, y:Float, b:Int):Void {
		downStack.push({x:x,y:y,b:b});
		DeltaTime.fixedUpdate.once(downDispatch, -5);
	}
	
	private static function downDispatch():Void {
		for (e in downStack) {
			switch e.b {
				case MouseButton.LEFT: eLeftDown.dispatch(e.x, e.y);
				case MouseButton.MIDDLE: eMiddleDown.dispatch(e.x, e.y);
				case MouseButton.RIGHT: eRightDown.dispatch(e.x, e.y);
			}
		}
		downStack = [];
	}
	
	public static function checkUp(b:Int):Bool {
		if (upStack.length > 0) {
			var l = ArrayTools.last(upStack);
			if (l == b) return false;
		}
		return true;
	}
	
	public static function checkDown(b:Int):Bool {
		if (upStack.length > 0) {
			var l = ArrayTools.last(downStack);
			if (l == null || l.b == b) return false;
		}
		return true;
	}
	
	public static function upHandler(x:Float, y:Float, b:Int):Void {
		upStack.push(b);
		DeltaTime.fixedUpdate.once(upDispatch, -3);
	}
	
	private static function upDispatch():Void {
		for (e in upStack) switch e {
			case MouseButton.LEFT: eLeftUp.dispatch(x, y);
			case MouseButton.MIDDLE: eMiddleUp.dispatch(x, y);
			case MouseButton.RIGHT: eRightUp.dispatch(x, y);
		}
		upStack = [];
	}
	
}