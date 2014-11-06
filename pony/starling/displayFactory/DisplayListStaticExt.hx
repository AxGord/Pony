package pony.starling.displayFactory;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import pony.starling.displayFactory.DisplayFactory.IDisplayObject;

/**
 * DisplayListStaticExt
 * @author Maletin
 */
class DisplayListStaticExt 
{
	public static function setTouchable(object:IDisplayObject, value:Bool):Bool
	{
		if (Std.is(object, starling.display.DisplayObject)) cast (object, starling.display.DisplayObject).touchable = value;
		if (Std.is(object, flash.display.InteractiveObject)) cast (object, flash.display.InteractiveObject).mouseEnabled = value;
		if (Std.is(object, flash.display.DisplayObjectContainer)) cast (object, flash.display.DisplayObjectContainer).mouseChildren = value;
		
		return value;
	}
	
	public static function getTouchable(object:IDisplayObject):Bool
	{
		if (Std.is(object, starling.display.DisplayObject)) return cast (object, starling.display.DisplayObject).touchable;
		if (Std.is(object, flash.display.InteractiveObject)) return cast (object, flash.display.InteractiveObject).mouseEnabled;
		
		return false;
	}
	
}