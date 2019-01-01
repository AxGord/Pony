package pony.ui.touch.starling.touchManager;
import flash.events.MouseEvent;
import flash.Lib;
import flash.ui.Multitouch;
import haxe.Timer;

/**
 * ...
 * @author Maletin
 */
class InputMode
{
	private static var _initialized:Bool = false;
	
	private static var _touchMode:Bool = false;
	private static var _activeTouchesCounter:Int = 0;
	
	private static var _ignoreMouseMoveUntil:Float = 0;
	private static var _ignoreMouseMoveTimeMills:Int = 200;
	
	public static function init():Void
	{
		if (_initialized) return;
		
		if (Multitouch.supportsTouchEvents)
		{
			Lib.current.stage.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, touchBegins);
			Lib.current.stage.addEventListener(flash.events.TouchEvent.TOUCH_END, touchEnds);
			
			#if !disableMouseInput
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseInput);
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseInput);
			#end
		}
		
		_initialized = true;
	}
	
	public static function touchMode():Bool
	{
		checkInitialized();
		return _touchMode;
	}
	
	private static function touchBegins(_):Void
	{
		//if (!_touchMode) trace("TOUCH MODE");
		
		_activeTouchesCounter++;
		
		_touchMode = true;
	}
	
	private static function touchEnds(_):Void
	{
		_activeTouchesCounter--;
		if (_activeTouchesCounter == 0)
		{
			_ignoreMouseMoveUntil = Timer.stamp() * 1000 + _ignoreMouseMoveTimeMills;
		}
	}
	
	#if !disableMouseInput
	private static function mouseInput(_):Void
	{
		if ( (_activeTouchesCounter == 0) && (_touchMode) && (Timer.stamp() * 1000 >= _ignoreMouseMoveUntil))
		{
			//trace("MOUSE MODE");
			
			_touchMode = false;
		}
	}
	#end
	
	private static function checkInitialized():Void
	{
		if (!_initialized) throw "Call InputMode.init() before usage (before any user input)";
	}
	
}