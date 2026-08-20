package pony.physics;

using StringTools;

/**
 * Temp
 * @author AxGord <axgord@gmail.com>
 */
abstract Temp(Float) {

	public var k(get, never): Float;
	public var c(get, never): Float;

	public inline function new(k: Float) this = k;

	@:to private inline function get_k(): Float return this;

	private inline function get_c(): Float return this - 273.15;

	@:from public static inline function fromK(k: Float): Temp return new Temp(k);

	public static inline function fromC(c: Float): Temp return new Temp(c + 273.15);

	@:from public static function fromString(s: String): Temp {
		s = s.trim();
		final ch: String = s.substr(s.length - 1).toLowerCase();
		final v: Float = Std.parseFloat(s.substr(0, s.length - 1));
		return switch ch {
			case 'c': fromC(v);
			case 'k': fromK(v);
			case _: throw 'Unknown temp measure';
		}
	}

	@:to private inline function toString(): String return c + 'C';

}
