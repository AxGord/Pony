package pony.touchManager.hitTestSources;
import flash.geom.Point;
import starling.display.DisplayObjectContainer;
import starling.core.Starling;

/**
 * ...
 * @author Maletin
 */
class StarlingHitTestSource implements IHitTestSource
{
	private var _container:DisplayObjectContainer;
	private var _point:Point = new Point();

	public function new(container:DisplayObjectContainer) 
	{
		_container = container;
	}
	
	/* INTERFACE touchManager.IHitTestSource */
	
	public function hitTest(x:Float, y:Float):Dynamic 
	{
		_point.x = x - Starling.current.viewPort.x;
		_point.y = y - Starling.current.viewPort.y;
		return _container.hitTest(_container.globalToLocal(_point), true);
	}
	
	public function parent(object:Dynamic):Dynamic
	{
		if (!Std.is(object, starling.display.DisplayObject)) return null;
		if (object == _container) return null;
		var objectsParent = object.parent;
		return objectsParent;
	}
	
}