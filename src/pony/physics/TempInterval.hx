package pony.physics;

import pony.Interval;
import pony.Pair;
import pony.physics.Temp;

/**
 * TempInterval
 * @author AxGord <axgord@gmail.com>
 */
abstract TempInterval(Interval<Temp>) from Interval<Temp> to Interval<Temp> {

	public var min(get, never): Temp;
	public var max(get, never): Temp;
	public var mid(get, never): Temp;

	private inline function get_min(): Temp return this.min;

	private inline function get_max(): Temp return this.max;

	private inline function get_mid(): Temp return this.mid;

	public inline function new(v: Interval<Temp>) this = v;

	@:from private static inline function fromStringInterval(it: Interval<String>): TempInterval {
		// ?? cannot replace this: Temp reads Float and String through separate @:from, one per branch
		final min: Temp = it.min == null ? Math.NEGATIVE_INFINITY : it.min; // noqa: prefer-null-coalescing
		return new Interval<Temp>(new Pair<Temp, Temp>(min, it.max));
	}

	@:to private inline function toStringInterval(): Interval<String> return new Interval<String>(new Pair<String, String>(min, max));

	@:to private inline function toString(): String return toStringInterval();

	@:from public static inline function fromString(s: String): TempInterval return Interval.fromString(s);

}
