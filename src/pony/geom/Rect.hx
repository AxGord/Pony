package pony.geom;

import pony.geom.Point;

/**
 * Rect / IntRect
 * @author AxGord <axgord@gmail.com>
 */
typedef SimpleRect<T> = {
	x: T,
	y: T,
	width: T,
	height: T
}

abstract Rect<T: Float>(SimpleRect<T>) to SimpleRect<T> from SimpleRect<T>  {

	public var x(get, set): T;
	public var y(get, set): T;
	public var width(get, set): T;
	public var height(get, set): T;

	public inline function new(x: T, y: T, width: T, height: T)
		this = { x: x, y: y, width: width, height: height };

	private inline function get_x(): T return this.x;
	private inline function get_y(): T return this.y;
	private inline function get_width(): T return this.width;
	private inline function get_height(): T return this.height;

	private inline function set_x(v: T): T return this.x = v;
	private inline function set_y(v: T): T return this.y = v;
	private inline function set_width(v: T): T return this.width = v;
	private inline function set_height(v: T): T return this.height = v;

	public inline function startAsPoint(): Point<T> return new Point<T>(x, y);

	@:to public static inline function fromIntToFloat(p: Rect<Int>): Rect<Float> return cast p;

}

abstract IntRect(SimpleRect<Int>) to SimpleRect<Int> from SimpleRect<Int> {

	public var x(get, never): Int;
	public var y(get, never): Int;
	public var width(get, never): Int;
	public var height(get, never): Int;

	@:op(A + B) public static inline function add1(lhs: IntRect, rhs: Point<Int>): IntRect
		return { x: lhs.getX() + rhs.x, y: lhs.getY() + rhs.y, width: lhs.getWidth(), height: lhs.getHeight() };

	@:op(A + B) public static inline function add2(lhs: IntRect, rhs: IntPoint): IntRect
		return { x: lhs.getX() + rhs.getX(), y: lhs.getY() + rhs.getY(), width: lhs.getWidth(), height: lhs.getHeight() };

	@:op(A - B) public static inline function m1(lhs: IntRect, rhs: Point<Int>): IntRect
		return { x: lhs.getX() - rhs.x, y: lhs.getY() - rhs.y, width: lhs.getWidth(), height: lhs.getHeight() };

	@:op(A - B) public static inline function m2(lhs: IntRect, rhs: IntPoint): IntRect
		return { x: lhs.getX() - rhs.getX(), y: lhs.getY() - rhs.getY(), width: lhs.getWidth(), height: lhs.getHeight() };

	public inline function getX(): Int return this.x;
	public inline function getY(): Int return this.y;

	public inline function getWidth(): Int return this.width;
	public inline function getHeight(): Int return this.height;

	private inline function get_x(): Int return this.x;
	private inline function get_y(): Int return this.y;
	private inline function get_width(): Int return this.width;
	private inline function get_height(): Int return this.height;
}