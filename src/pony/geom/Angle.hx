package pony.geom;

/**
 * Angle
 * @author AxGord <axgord@gmail.com>
 */
abstract Angle(Float) to Float {

	public static inline var MAX: Int = 360;

	public var percent(get, never): Float;

	public inline function new(v) this = v;

	@:from private static inline function fromFloat(v: Float): Angle {
		v = v % MAX;
		if (v < 0) v += MAX;
		return new Angle(v);
	}

	@:from private static inline function fromInt(v: Int): Angle return fromFloat(v);

	private inline function get_percent(): Float return this / MAX;

	@:op(A + B) private static inline function add(a: Angle, b: Angle): Angle return (a: Float) + (b: Float);
	@:op(A / B) private static inline function div(a: Angle, b: Angle): Angle return (a: Float) / (b: Float);
	@:op(A * B) private static inline function mul(a: Angle, b: Angle): Angle return (a: Float) * (b: Float);
	@:op(A - B) private static inline function sub(a: Angle, b: Angle): Angle return (a: Float) - (b: Float);
	@:op(A > B) private static inline function gt(a: Angle, b: Angle): Bool return (a: Float) > (b: Float);
	@:op(A >= B) private static inline function gte(a: Angle, b: Angle): Bool return (a: Float) >= (b: Float);
	@:op(A < B) private static inline function lt(a: Angle, b: Angle): Bool return (a: Float) < (b: Float);
	@:op(A <= B) private static inline function lte(a: Angle, b: Angle): Bool return (a: Float) <= (b: Float);
	@:op(A % B) private static inline function mod(a: Angle, b: Angle): Angle return (a: Float) % (b: Float);

}