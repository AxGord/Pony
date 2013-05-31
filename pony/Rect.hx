package pony;
import pony.Point;
/**
 * ...
 * @author AxGord
 */
typedef Rect<T> = { x:T, y:T, width:T, height:T }

abstract IntRect(Rect<Int>) to Rect<Int> from Rect<Int> {
	
	@:op(A + B) inline static public function add1(lhs:IntRect, rhs:Point<Int>):IntRect
		return { x:lhs.x + rhs.x, y:lhs.y + rhs.y, width: lhs.width, height: lhs.height };
	
	@:op(A + B) inline static public function add2(lhs:IntRect, rhs:IntPoint):IntRect 
		return { x:lhs.x + rhs.getX(), y:lhs.y + rhs.getY(), width: lhs.width, height: lhs.height };
		
	@:op(A - B) inline static public function m1(lhs:IntRect, rhs:Point<Int>):IntRect
		return { x:lhs.x - rhs.x, y:lhs.y - rhs.y, width: lhs.width, height: lhs.height };
	
	@:op(A - B) inline static public function m2(lhs:IntRect, rhs:IntPoint):IntRect 
		return { x:lhs.x - rhs.getX(), y:lhs.y - rhs.getY(), width: lhs.width, height: lhs.height };
	
	public inline function getX():Int return this.x;
	public inline function getY():Int return this.y;
}