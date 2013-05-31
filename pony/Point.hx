package pony;

/**
 * ...
 * @author AxGord
 */
typedef Point<T> = { x:T, y:T }

abstract IntPoint(Point<Int>) to Point<Int> from Point<Int> {
	
	@:op(A + B) inline static public function add1(lhs:IntPoint, rhs:Point<Int>):IntPoint
		return { x:lhs.x + rhs.x, y:lhs.y + rhs.y };
		
	@:op(A + B) inline static public function add2(lhs:IntPoint, rhs:IntPoint):IntPoint
		return { x:lhs.x + rhs.x, y:lhs.y + rhs.y };
		
	@:op(A - B) inline static public function m1(lhs:IntPoint, rhs:Point<Int>):IntPoint
		return { x:lhs.x - rhs.x, y:lhs.y - rhs.y };
		
	@:op(A - B) inline static public function m2(lhs:IntPoint, rhs:IntPoint):IntPoint
		return { x:lhs.x - rhs.x, y:lhs.y - rhs.y };
		
	public inline function getX():Int return this.x;
	public inline function getY():Int return this.y;
	
	@:from static public inline function fromRect(r:Rect<Int>):IntPoint return { x: r.x, y: r.y };
}
