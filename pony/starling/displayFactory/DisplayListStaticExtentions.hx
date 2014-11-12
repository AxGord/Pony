package pony.starling.displayFactory;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.geom.Rectangle;
import pony.starling.displayFactory.DisplayFactory.IDisplayObject;
import pony.starling.utils.UniversalDrag;

/**
 * DisplayListStaticExtentions
 * @author Maletin
 */
class DisplayListStaticExtentions 
{
	public static function setTouchable(object:IDisplayObject, value:Bool):Void
	{
		if (Std.is(object, starling.display.DisplayObject)) StarlingStaticExtentions.setTouchable(cast object, value);
		if (Std.is(object, flash.display.DisplayObject)) FlashStaticExtentions.setTouchable(cast object, value);
	}
	
	public static function getTouchable(object:IDisplayObject):Bool
	{
		if (Std.is(object, starling.display.DisplayObject)) return StarlingStaticExtentions.getTouchable(cast object);
		if (Std.is(object, flash.display.DisplayObject)) return FlashStaticExtentions.getTouchable(cast object);
		
		return false;
	}
	
	public static function startUniversalDrag(dragged:IDisplayObject, lockCenter:Bool = false, bounds:Rectangle = null):Void { UniversalDrag.startUniversalDrag(dragged, lockCenter, bounds); }
	public static function stopUniversalDrag(dragged:IDisplayObject):Void { UniversalDrag.stopUniversalDrag(dragged); }
	public static function stopUniversalDragKinetic(dragged:IDisplayObject):Void { UniversalDrag.stopUniversalDragKinetic(dragged); }
}

class StarlingStaticExtentions
{
	public static function setTouchable(object:starling.display.DisplayObject, value:Bool):Void { object.touchable = value; }
	public static function getTouchable(object:starling.display.DisplayObject):Bool { return object.touchable; }
	
	public static function startUniversalDrag(dragged:starling.display.DisplayObject, lockCenter:Bool = false, bounds:Rectangle = null):Void { UniversalDrag.startUniversalDrag(cast dragged, lockCenter, bounds); }
	public static function stopUniversalDrag(dragged:starling.display.DisplayObject):Void { UniversalDrag.stopUniversalDrag(cast dragged); }
	public static function stopUniversalDragKinetic(dragged:starling.display.DisplayObject):Void { UniversalDrag.stopUniversalDragKinetic(cast dragged); }
}

class FlashStaticExtentions
{
	public static function setTouchable(object:flash.display.DisplayObject, value:Bool):Void
	{
		if (Std.is(object, flash.display.InteractiveObject)) cast (object, flash.display.InteractiveObject).mouseEnabled = value;
		if (Std.is(object, flash.display.DisplayObjectContainer)) cast (object, flash.display.DisplayObjectContainer).mouseChildren = value;
	}
	
	public static function getTouchable(object:flash.display.DisplayObject):Bool
	{
		if (Std.is(object, flash.display.InteractiveObject)) return cast (object, flash.display.InteractiveObject).mouseEnabled;
		
		return false;
	}
	
	public static function startUniversalDrag(dragged:flash.display.DisplayObject, lockCenter:Bool = false, bounds:Rectangle = null):Void { UniversalDrag.startUniversalDrag(cast dragged, lockCenter, bounds); }
	public static function stopUniversalDrag(dragged:flash.display.DisplayObject):Void { UniversalDrag.stopUniversalDrag(cast dragged); }
	public static function stopUniversalDragKinetic(dragged:flash.display.DisplayObject):Void { UniversalDrag.stopUniversalDragKinetic(cast dragged); }
}