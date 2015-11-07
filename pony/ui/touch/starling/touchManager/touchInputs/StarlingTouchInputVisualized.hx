package pony.ui.touch.starling.touchManager.touchInputs;

import flash.geom.Point;
import flash.Vector;
import pony.ui.touch.starling.touchManager.InputMode;
import pony.ui.touch.starling.touchManager.TouchManager;
import starling.display.DisplayObject;
import starling.display.DisplayObjectContainer;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;

/**
 * ...
 * @author Maletin
 */
class StarlingTouchInputVisualized extends StarlingTouchInput
{
	private var _visualizers:Map<Int, DisplayObject> = new Map<Int, DisplayObject>();

	public function new(displayObject:DisplayObjectContainer) 
	{
		super(displayObject);
	}
	
	override private function onTouch(e:TouchEvent):Void
	{
		super.onTouch(e);
		
		var touches:Vector<Touch> = e.getTouches(cast(e.target, DisplayObject));
		for (i in 0...touches.length)
		{		
			var touch:Touch = touches[i];
			
			if (touch == null) return;

			if (touch.phase == TouchPhase.BEGAN)
			{
				addVisualizer(touch);
			}
			
			if (touch.phase == TouchPhase.ENDED)
			{
				destroyVisualizer(touch);
			}
			
			
			if ( (touch.phase == TouchPhase.MOVED) ||
				( (touch.phase == TouchPhase.HOVER) && (!InputMode.touchMode()) ) )
			{
				moveVisualizer(touch);
			}
		}
	}	
	
	private function addVisualizer(touch:Touch):Void
	{
		if (!_visualizers.exists(touch.id))
		{
			var tf:TextField = new TextField(200, 50, ("" + touch.id));
			tf.border = true;
			tf.touchable = false;
			untyped _displayObject.addChild(tf);
			
			_visualizers.set(touch.id, tf);
		}
		
		moveVisualizer(touch);
	}
	
	private function moveVisualizer(touch:Touch):Void
	{
		if (!_visualizers.exists(touch.id)) return;
		
		var tf = _visualizers.get(touch.id);
		
		var point:Point = new Point(touch.globalX, touch.globalY);
		point = _displayObject.globalToLocal(point);
		
		tf.x = point.x;
		tf.y = point.y;
	}
	
	private function destroyVisualizer(touch:Touch):Void
	{
		if (!_visualizers.exists(touch.id)) return;
		
		var tf = _visualizers.get(touch.id);
		untyped _displayObject.removeChild(tf);
		_visualizers.remove(touch.id);
	}
	
}