package pony.geom;

import pony.ds.UHPair;

typedef PointImpl<T> = {
	x: T,
	y: T
}

typedef ObjWithPoint = {
	var x(default, never): Float;
	var y(default, never): Float;
}

typedef ObjWithPointForSet = {
	var x: Float;
	var y: Float;
}

typedef ObjWithSetPosition = {
	function setPosition(x: Float, y: Float): Void;
}

/**
 * Point / IntPoint
 * @author AxGord <axgord@gmail.com>
 */
abstract Point<T: Float>(PointImpl<T>) from PointImpl<T> to PointImpl<T> {

	public var x(get, set): T;
	public var y(get, set): T;
	public inline function new(x: T, y: T) this = { x: x, y: y };
	private inline function get_x(): T return this.x;
	private inline function get_y(): T return this.y;
	private inline function set_x(v: T): T return this.x = v;
	private inline function set_y(v: T): T return this.y = v;
	public inline function toString(): String return '(${this.x}, ${this.y})';

	@:to public inline function toFloat(): PointImpl<Float> return cast this;

	@:to public static inline function toInt(p: Point<Float>): Point<Int> return new Point(Std.int(p.x), Std.int(p.y));

	@:from public static inline function fromUHPair(p: UHPair): Point<UInt> return new Point<UInt>(p.a, p.b);

	@:op(A / B) public static inline function div2<T: Float>(lhs: Point<T>, rhs: Point<T>): Point<Float>
		return { x: lhs.x / rhs.x, y: lhs.y / rhs.y };

	@:op(A / B) public static inline function div1<T: Float>(lhs: Point<T>, rhs: T): Point<Float>
		return { x: lhs.x / rhs, y: lhs.y / rhs };

	@:op(A / B) public static inline function div2i<T: Int>(lhs: Point<T>, rhs: Point<T>): Point<Float>
		return { x: lhs.x / rhs.x, y: lhs.y / rhs.y };

	@:op(A / B) public static inline function div1i<T: Int>(lhs: Point<T>, rhs: T): Point<Float>
		return { x: lhs.x / rhs, y: lhs.y / rhs };

	@:op(A / B) public static inline function div2if<T:Int>(lhs:Point<T>, rhs:Point<Float>):Point<Float>
		return { x:lhs.x / rhs.x, y:lhs.y / rhs.y };

	@:op(A / B) public static inline function div1if<T: Int>(lhs: Point<T>, rhs: Float): Point<Float>
		return { x: lhs.x / rhs, y: lhs.y / rhs };

	@:op(A * B) public static inline function mul2<T: Float>(lhs: Point<T>, rhs: Point<T>): Point<T>
		return { x: lhs.x * rhs.x, y: lhs.y * rhs.y };

	@:op(A * B) public static inline function mul1<T: Float>(lhs: Point<T>, rhs: T): Point<T>
		return { x: lhs.x * rhs, y: lhs.y * rhs };

	@:op(A + B) public static inline function add2<T: Float>(lhs: Point<T>, rhs: Point<T>): Point<T>
		return { x: lhs.x + rhs.x, y: lhs.y + rhs.y };

	@:op(A + B) public static inline function add1<T: Float>(lhs: Point<T>, rhs: T): Point<T>
		return { x: lhs.x + rhs, y: lhs.y + rhs };

	@:op(A - B) public static inline function sub2<T: Float>(lhs: Point<T>, rhs: Point<T>): Point<T>
		return { x: lhs.x - rhs.x, y: lhs.y - rhs.y };

	@:op(A - B) public static inline function sub1<T: Float>(lhs: Point<T>, rhs: T): Point<T>
		return { x: lhs.x - rhs, y: lhs.y - rhs };

	@:op(A == B) public inline function compare(b: Point<T>): Bool return x == b.x && y == b.y;

	public inline function minMax(b: Point<T>): Point<T>
		return new Point<T>(this.x < b.x ? this.x : b.x, this.y > b.y ? this.y : b.y);

	public inline function min(b: Point<T>): Point<T>
		return new Point<T>(this.x < b.x ? this.x : b.x, this.y < b.y ? this.y : b.y);

	public inline function max(b: Point<T>): Point<T>
		return new Point<T>(this.x > b.x ? this.x : b.x, this.y > b.y ? this.y : b.y);

	public static inline function random(): Point<Float> return new Point<Float>(Math.random(), Math.random());

	public inline function setXY(obj: ObjWithPointForSet): Void {
		obj.x = x;
		obj.y = y;
	}

	public inline function setPosition(obj: ObjWithSetPosition): Void obj.setPosition(x, y);

	@:from public static inline function ofObj(obj: ObjWithPoint): Point<Float> return new Point<Float>(obj.x, obj.y);
	@:from public static inline function ofFloat(v: Float): Point<Float> return new Point<Float>(v, v);
	@:from public static inline function ofInt(v: Int): Point<Int> return new Point<Int>(v, v);

	#if heaps
	@:keep private function keepHackForHeaps(): Any return new h2d.Object().setPosition;
	#end
}

abstract IntPoint(PointImpl<Int> ) to PointImpl<Int> from PointImpl<Int> {

	public static var OneUp: IntPoint = new IntPoint(0, -1);
	public static var OneDown: IntPoint = new IntPoint(0, 1);
	public static var OneLeft: IntPoint = new IntPoint(-1, 0);
	public static var OneRight: IntPoint = new IntPoint(1, 0);

	public var x(get, never): Int;
	public var y(get, never): Int;

	public function new(x: Int, y: Int) this = {x: x, y: y};

	@:op(A + B) public static inline function add1(lhs: IntPoint, rhs: Point<Int>): IntPoint
		return { x: lhs.getX() + rhs.x, y: lhs.getY() + rhs.y };

	@:op(A + B) public static inline function add2(lhs: IntPoint, rhs: IntPoint): IntPoint
		return { x: lhs.getX() + rhs.getX(), y: lhs.getY() + rhs.getY() };

	@:op(A - B) public static inline function m1(lhs: IntPoint, rhs: Point<Int>): IntPoint
		return { x: lhs.getX() - rhs.x, y: lhs.getY() - rhs.y };

	@:op(A - B) public static inline function m2(lhs: IntPoint, rhs: IntPoint): IntPoint
		return { x: lhs.getX() - rhs.getX(), y: lhs.getY() - rhs.getY() };

	private inline function get_x(): Int return this.x;
	private inline function get_y(): Int return this.y;
	public inline function getX(): Int return this.x;
	public inline function getY(): Int return this.y;

	@:from public static inline function fromRect(r: Rect<Int>): IntPoint return { x: r.x, y: r.y };

	@:op(A == B) private inline function equal(b: IntPoint): Bool return x == b.x && y == b.y;

	@:from public static function fromDirection(d: Direction): IntPoint {
		return switch d {
			case Direction.Up: OneUp;
			case Direction.Down: OneDown;
			case Direction.Left: OneLeft;
			case Direction.Right: OneRight;
			case _: new IntPoint(0, 0);
		}
	}

	@:from public static function fromIntIterator(it: IntIterator): IntPoint {
		return new IntPoint(@:privateAccess it.min, @:privateAccess it.max);
	}

	public inline function setXY(obj: ObjWithPointForSet): Void {
		obj.x = x;
		obj.y = y;
	}

	public inline function setPosition(obj: ObjWithSetPosition): Void obj.setPosition(x, y);

	public function toString(): String return '(${this.x}, ${this.y})';

}
