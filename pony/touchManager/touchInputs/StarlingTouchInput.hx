package pony.touchManager.touchInputs;
import flash.events.MouseEvent;
import flash.Lib;
import flash.Vector;
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import pony.touchManager.InputMode;

/**
 * ...
 * @author Maletin
 */
class StarlingTouchInput
{
	private var _displayObject:DisplayObject;
	
	public function new(displayObject:DisplayObject) 
	{
		_displayObject = displayObject;
		
		InputMode.init();
		
		_displayObject.addEventListener(TouchEvent.TOUCH, onTouch);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}
	
	private function onTouch(e:TouchEvent):Void
	{
		var touches:Vector<Touch> = e.getTouches(cast(e.target, DisplayObject));
		for (i in 0...touches.length)
		{		
			var touch:Touch = touches[i];
			
			if (touch == null) return;

			if (touch.phase == TouchPhase.BEGAN)
			{
				TouchManager.down(touch.globalX, touch.globalY, InputMode.touchMode(), touch.id);
			}
			
			if (touch.phase == TouchPhase.ENDED)
			{
				TouchManager.up(touch.globalX, touch.globalY, InputMode.touchMode(), touch.id);
			}
			
			
			if ( (touch.phase == TouchPhase.MOVED) ||
				( (touch.phase == TouchPhase.HOVER) && (!InputMode.touchMode()) ) )
			{
				TouchManager.move(touch.globalX, touch.globalY, InputMode.touchMode(), touch.id);
			}
		}
	}
	
	private function onMouseWheel(e:MouseEvent):Void
	{
		TouchManager.mouseWheel(e.delta);
	}	
}