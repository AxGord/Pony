package pony.ds;

/**
 * UHPair
 * UInt numbers pair
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) abstract UHPair(UInt) to UInt {

	public static inline var MAX_VALUE_A: UInt = 21474;
	public static inline var MAX_VALUE_B: UInt = 83647;
	private static inline var ASTEP: UInt = 100000;

	public var a(get, set): UInt;
	public var b(get, set): UInt;

	public inline function new(a: UInt, b: UInt) this = a * ASTEP + b;

	public inline function get_a(): UInt return Std.int(this / ASTEP);
	public inline function set_a(v: UInt): UInt return this = v * ASTEP + b;
	public inline function get_b(): UInt return this % ASTEP;
	public inline function set_b(v: UInt): UInt return this = a * ASTEP + v;

	@:to public inline function toString(): String return @:nullSafety(Off) '($a, $b)';

}