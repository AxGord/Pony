package pony.geom;

/**
 * Borders
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
abstract Border<T: Float>({ top: T, left: T, right: T, bottom: T }) {

	public var top(get, never): T;
	public var left(get, never): T;
	public var right(get, never): T;
	public var bottom(get, never): T;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function new(top: T, ?left: Null<T>, ?right: Null<T>, ?bottom: Null<T>) {
		if (left == null) left = top;
		if (right == null) right = left;
		if (bottom == null) bottom = top;
		this = {top: top, left: left, right: right, bottom: bottom};
	}

	@:from #if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function fromNumber<T: Float>(v: T): Border<T> return new Border(v);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_top(): T return this.top;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_left(): T return this.left;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_right(): T return this.right;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_bottom(): T return this.bottom;

	@:from public static function fromString(v: String): Border<Float> {
		if (v == null || v == '') return new Border<Float>(0);
		return fromArray(v.split(' ').map(Std.parseFloat));
	}

	@:from public static function fromArray<T: Float>(v: Array<T>): Border<T> {
		return switch v.length {
			case 0: cast new Border(0);
			case 1: new Border(v[0]);
			case 2: new Border(v[0], v[1]);
			case 3: new Border(v[0], v[1], v[2]);
			case 4: new Border(v[0], v[1], v[2], v[3]);
			case _: throw 'Uncorrect array length';
		}
	}

	@:op(A * B) #if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function mul(rhs: Float): Border<Float>
		return new Border(top * rhs, left * rhs, right * rhs, bottom * rhs);

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function getRectFromSize(size: Point<T>): Rect<T>
		return {x: left, y: top, width: size.x - left - right, height: size.y - top - bottom};

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function toInt(): Border<Int>
		return new Border(Std.int(top), Std.int(left), Std.int(right), Std.int(bottom));

}