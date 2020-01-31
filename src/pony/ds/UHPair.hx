package pony.ds;

import pony.geom.Point;

/**
 * Half UInt numbers pair
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) abstract UHPair(UInt) to UInt {

	public static inline var MAX_VALUE_A: UInt = 42949;
	public static inline var MID_VALUE_A: UInt = 21474;
	public static inline var MAX_VALUE_B: UInt = 99999;
	public static inline var MID_VALUE_B: UInt = 49999;
	public static inline var MAX_VALUE_B_MAX_A: UInt = 67295;
	public static inline var MID_VALUE_B_MAX_A: UInt = 33647;
	public static inline var MAP_MAX_VALUE_A: UInt = 21474;
	public static inline var MAP_MID_VALUE_A: UInt = 10737;
	public static inline var MAP_MAX_VALUE_B: UInt = MAX_VALUE_B;
	public static inline var MAP_MID_VALUE_B: UInt = 41823;
	public static inline var MAP_MAX_VALUE_B_MAX_A: UInt = 83647;
	public static inline var ASTEP: UInt = 100000;
	public static inline var MAX_PAIR: UHPair = cast MAX_VALUE_A * ASTEP + MAX_VALUE_B_MAX_A;
	public static inline var MID_PAIR: UHPair = cast MID_VALUE_A * ASTEP + MID_VALUE_B;
	public static inline var MAP_MAX_PAIR: UHPair = cast MAP_MAX_VALUE_A * ASTEP + MAP_MAX_VALUE_B_MAX_A;
	public static inline var MAP_MID_PAIR: UHPair = cast MAP_MID_VALUE_A * ASTEP + MAP_MID_VALUE_B;

	public var a(get, set): UInt;
	public var b(get, set): UInt;

	public inline function new(a: UInt, b: UInt) this = a * ASTEP + b;

	public inline function get_a(): UInt return Std.int(this / ASTEP);
	public inline function set_a(v: UInt): UInt return this = v * ASTEP + b;
	public inline function get_b(): UInt return this % ASTEP;
	public inline function set_b(v: UInt): UInt return this = a * ASTEP + v;

	@:to public inline function toString(): String return @:nullSafety(Off) '($a, $b)';
	@:to public inline function toPoint(): Point<UInt> return new Point<UInt>(a, b);

}