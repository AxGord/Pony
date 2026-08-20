package pony.ui.touch.starling.touchManager.hitTestSources;

import flash.geom.Point;
import starling.core.Starling;
import starling.display.DisplayObjectContainer;

/**
 * ...
 * @author Maletin
 */
class StarlingHitTestSource implements IHitTestSource {

	private final _container: DisplayObjectContainer;
	private final _point: Point = new Point();

	public function new(container: DisplayObjectContainer) {
		_container = container;
	}

	/* INTERFACE touchManager.IHitTestSource */
	public function hitTest(x: Float, y: Float): Dynamic {
		_point.x = x - Starling.current.viewPort.x;
		_point.y = y - Starling.current.viewPort.y;
		return _container.hitTest(_container.globalToLocal(_point), true);
	}

	public function parent(object: Dynamic): Dynamic {
		return if (!Std.is(object, starling.display.DisplayObject))
			null
		else if (object == _container)
			null
		else
			object.parent;
	}

}
