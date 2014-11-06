package pony.starling.utils;

import com.greensock.TweenMax;
import flash.geom.Rectangle;
import starling.display.DisplayObject;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;

/**
 * StarlingDrag
 * @author Maletin
 */
class StarlingDrag 
{
	private static var _dragged:DisplayObject;
	private static var _dragBounds:Rectangle;
	
	private static var _xSpeed:Float;
	private static var _ySpeed:Float;
	
	private static var _activeTween:TweenMax;
	
	private static var SPEED_MP:Float = 350;
	private static var SPEED_POW:Float = 1.4;
	
	public static function startDrag(dragged:DisplayObject, lockCenter:Bool = false, bounds:Rectangle = null):Void
	{
		_dragged = dragged;
		//TODO lockCenter
		
		_dragBounds = bounds;
		
		_xSpeed = 0;
		_ySpeed = 0;
		
		TouchManager.addListener(TouchManager.GLOBAL, onDrag, [TouchEventType.Move]);
		//trace("StartDrag");
		
		if (_activeTween != null) _activeTween.kill();
	}
	
	private static function onDrag(e:TouchManagerEvent):Void
	{
		//trace("onDrag e.globalX = " + e.globalX + ", e.previousGlobalX = " + e.previousGlobalX + ", e.globalY = " + e.globalY + ", e.previousGlobalY = " + e.previousGlobalY);
		_dragged.x += e.globalX - e.previousGlobalX;
		_dragged.y += e.globalY - e.previousGlobalY;
		
		//_xSpeed = e.globalX - e.previousGlobalX;
		//_ySpeed = e.globalY - e.previousGlobalY;
		
		_xSpeed = e.speedX;
		_ySpeed = e.speedY;
		
		toBounds();
	}
	
	private static function toBounds():Void
	{
		if (_dragBounds != null)
		{
			if (_dragged.x + _dragged.width > _dragBounds.width) _dragged.x = _dragBounds.width - _dragged.width;
			if (_dragged.y + _dragged.height > _dragBounds.height) _dragged.y = _dragBounds.height - _dragged.height;
			if (_dragged.x < _dragBounds.x) _dragged.x = _dragBounds.x;
			if (_dragged.y < _dragBounds.y) _dragged.y = _dragBounds.y;
		}
	}
	
	public static function stopDrag(dragged:DisplayObject):Void
	{
		TouchManager.removeListener(TouchManager.GLOBAL, onDrag);
		
		_dragged = null;
	}
	
	public static function stopDragKinetic(dragged:DisplayObject):Void
	{
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
		
		_activeTween = TweenMax.to(_dragged, 0.7, { x:toX, y:toY } );
		
		_dragged = null;
	}
	
	private static function sign(value:Float):Int
	{
		return value >= 0 ? 1 : -1;
	}
}