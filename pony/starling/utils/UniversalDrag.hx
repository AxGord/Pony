package pony.starling.utils;

import com.greensock.TweenMax;
import flash.geom.Point;
import flash.geom.Rectangle;
import pony.starling.displayFactory.DisplayFactory.IDisplayObject;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;
#if starling
import starling.display.DisplayObject;
#end

/**
 * UniversalDrag
 * @author Maletin
 */
class UniversalDrag 
{
	public static inline var KINETIC_DRAG_DURATION:Float = 0.7;
	
	private static var _dragged:IDisplayObject;
	private static var _dragBounds:Rectangle;
	
	private static var _xSpeed:Float;
	private static var _ySpeed:Float;
	
	private static var _activeTween:TweenMax;
	
	private static var SPEED_MP:Float = 350;
	private static var SPEED_POW:Float = 1.4;
	
	private static var _startX:Float = 0;
	private static var _startY:Float = 0;
	
	private static var _dragTouchId:Int = -1;
	private static var bufferPoint:Point = new Point(0, 0);
	
	
	public static function startUniversalDrag(dragged:IDisplayObject, lockCenter:Bool = false, bounds:Rectangle = null):Void
	{
		if (_dragged != null) stopUniversalDrag(_dragged);
		
		_dragged = dragged;
		
		_dragBounds = bounds;
		
		_xSpeed = 0;
		_ySpeed = 0;
		
		var lastEvent = TouchManager.getLastDownEvent();
		_dragTouchId = lastEvent.touchID;
		
		if (lockCenter)
		{
			_startX = _startY = 0;
		}
		else
		{
			bufferPoint.x = lastEvent.globalX;
			bufferPoint.y = lastEvent.globalY;
			bufferPoint = _dragged.parent.globalToLocal(bufferPoint);
			_startX = _dragged.x - bufferPoint.x;
			_startY = _dragged.y - bufferPoint.y;
		}
		
		TouchManager.addListener(TouchManager.GLOBAL, onDrag, [TouchEventType.Move]);
		
		if (_activeTween != null) _activeTween.kill();
	}
	
	private static function onDrag(e:TouchManagerEvent):Void
	{
		if (e.touchID != _dragTouchId) return;
		
		bufferPoint.x = e.globalX;
		bufferPoint.y = e.globalY;
		bufferPoint = _dragged.parent.globalToLocal(bufferPoint);
		_dragged.x = bufferPoint.x + _startX;
		_dragged.y = bufferPoint.y + _startY;
		
		_xSpeed = e.speedX;
		_ySpeed = e.speedY;
		
		toBounds();
	}
	
	private static function toBounds():Void
	{		
		if (_dragBounds != null)
		{
			if (_dragged.x > _dragBounds.right)  _dragged.x = _dragBounds.right;
			if (_dragged.y > _dragBounds.bottom) _dragged.y = _dragBounds.bottom;
			if (_dragged.x < _dragBounds.x) _dragged.x = _dragBounds.x;
			if (_dragged.y < _dragBounds.y) _dragged.y = _dragBounds.y;
		}
	}
	
	public static function stopUniversalDrag(dragged:IDisplayObject):Void
	{
		if (_dragged != dragged) return;
		
		TouchManager.removeListener(TouchManager.GLOBAL, onDrag);
		
		_dragged = null;
	}
	
	public static function stopUniversalDragKinetic(dragged:IDisplayObject):Void
	{
		if (_dragged != dragged) return;
		
		TouchManager.removeListener(TouchManager.GLOBAL, onDrag);
		
		if (_dragged == null) return;
		
		var prevX:Float = _dragged.x;
		var prevY:Float = _dragged.y;
		
		//trace("_xSpeed = " + _xSpeed + ", (" + SPEED_MP + " * Math.pow(Math.abs(_xSpeed), " + SPEED_POW + ") * sign(_xSpeed) ) = " + (SPEED_MP * Math.pow(Math.abs(_xSpeed), SPEED_POW) * sign(_xSpeed)) + "\n" + 
			  //"_ySpeed = " + _ySpeed + ", (" + SPEED_MP + " * Math.pow(Math.abs(_ySpeed), " + SPEED_POW + ") * sign(_ySpeed) ) = " + (SPEED_MP * Math.pow(Math.abs(_ySpeed), SPEED_POW) * sign(_ySpeed)));
		
		_dragged.x += SPEED_MP * Math.pow(Math.abs(_xSpeed), SPEED_POW) * sign(_xSpeed);
		_dragged.y += SPEED_MP * Math.pow(Math.abs(_ySpeed), SPEED_POW) * sign(_ySpeed);
		
		toBounds();
		
		var toX:Float = _dragged.x;
		var toY:Float = _dragged.y;
		
		_dragged.x = prevX;
		_dragged.y = prevY;
		
		_activeTween = TweenMax.to(_dragged, KINETIC_DRAG_DURATION, { x:toX, y:toY } );
		
		_dragged = null;
	}
	
	private static function sign(value:Float):Int
	{
		return value >= 0 ? 1 : -1;
	}
}

#if starling
class UniversalDragStarling
{
	public static function startUniversalDrag(dragged:starling.display.DisplayObject, lockCenter:Bool = false, bounds:Rectangle = null):Void { UniversalDrag.startUniversalDrag(cast dragged, lockCenter, bounds); }
	public static function stopUniversalDrag(dragged:starling.display.DisplayObject):Void { UniversalDrag.stopUniversalDrag(cast dragged); }
	public static function stopUniversalDragKinetic(dragged:starling.display.DisplayObject):Void { UniversalDrag.stopUniversalDragKinetic(cast dragged); }
}
#end

class UniversalDragFlash
{
	public static function startUniversalDrag(dragged:flash.display.DisplayObject, lockCenter:Bool = false, bounds:Rectangle = null):Void { UniversalDrag.startUniversalDrag(cast dragged, lockCenter, bounds); }
	public static function stopUniversalDrag(dragged:flash.display.DisplayObject):Void { UniversalDrag.stopUniversalDrag(cast dragged); }
	public static function stopUniversalDragKinetic(dragged:flash.display.DisplayObject):Void { UniversalDrag.stopUniversalDragKinetic(cast dragged); }
}