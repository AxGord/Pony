package pony.touchManager.touchInputs;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import pony.touchManager.InputMode;

/**
 * ...
 * @author Maletin
 */
class NativeFlashTouchInput
{
	private var _displayObject:DisplayObject;

	public function new(displayObject:DisplayObject) 
	{
		_displayObject = displayObject;
		
		InputMode.init();
		
		_displayObject.addEventListener(MouseEvent.MOUSE_UP, onUp);
		_displayObject.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		_displayObject.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		_displayObject.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		
		_displayObject.addEventListener(TouchEvent.TOUCH_END, onTouchUp);
		_displayObject.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown);
		_displayObject.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
	}
	
	private function onUp(e:MouseEvent):Void
	{
		if (!InputMode.touchMode())
		{
			TouchManager.up(e.stageX, e.stageY, false);
			TouchManager.move(e.stageX, e.stageY, false);
		}
	}
	
	private function onDown(e:MouseEvent):Void
	{
		if (!InputMode.touchMode())
		{
			TouchManager.down(e.stageX, e.stageY, false);
		}
	}
	
	private function onMove(e:MouseEvent):Void
	{
		if (!InputMode.touchMode())
		{
			TouchManager.move(e.stageX, e.stageY, false, 0, e.buttonDown);
		}
	}
	
	private function onMouseWheel(e:MouseEvent):Void
	{
		TouchManager.mouseWheel(e.delta);
	}
	
	private function onTouchUp(e:TouchEvent):Void
	{
		if (InputMode.touchMode())
		{
			TouchManager.up(e.stageX, e.stageY, true, e.touchPointID);
		}
	}
	
	private function onTouchDown(e:TouchEvent):Void
	{
		if (InputMode.touchMode())
		{
			TouchManager.down(e.stageX, e.stageY, true, e.touchPointID);
		}
	}
	
	private function onTouchMove(e:TouchEvent):Void
	{
		if (InputMode.touchMode())
		{
			TouchManager.move(e.stageX, e.stageY, true, e.touchPointID);
		}
	}
	
}