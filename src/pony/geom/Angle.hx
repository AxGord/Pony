package pony.geom;

/**
 * Angle
 * @author AxGord <axgord@gmail.com>
 */
abstract Angle(Float) to Float {

	public var percent(get,never):Float;
	
	inline public function new(v) this = v;
	
	@:from inline static private function fromFloat(v:Float):Angle {
		v = v % 360;
		if (v < 0) v += 360;
		return new Angle(v);
	}
	
	@:from inline static private function fromInt(v:Int):Angle return fromFloat(v);
	
	inline private function get_percent():Float return this / 360;
	
	
	@:op(A + B) private static inline function add(a:Angle, b:Angle):Angle return (a:Float) + (b:Float);
	@:op(A / B) private static inline function div(a:Angle, b:Angle):Angle return (a:Float) / (b:Float);
	@:op(A * B) private static inline function mul(a:Angle, b:Angle):Angle return (a:Float) * (b:Float);
	@:op(A - B) private static inline function sub(a:Angle, b:Angle):Angle return (a:Float) - (b:Float);
	
	
	@:op(A > B) private static inline function gt(a:Angle, b:Angle):Bool return (a:Float) > (b:Float);
	@:op(A >= B) private static inline function gte(a:Angle, b:Angle):Bool return (a:Float) >= (b:Float);

	@:op(A < B) private static inline function lt(a:Angle, b:Angle):Bool return (a:Float) < (b:Float);
	@:op(A <= B) private static inline function lte(a:Angle, b:Angle):Bool return (a:Float) <= (b:Float);
	
	@:op(A % B) private static inline function mod(a:Angle, b:Angle):Angle return (a:Float) % (b:Float);
}