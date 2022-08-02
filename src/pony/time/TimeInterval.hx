package pony.time;

import pony.math.MathTools;

using Reflect;

private typedef TimeIntervalImpl = {
	min:Time,
	max:Time
}

/**
 * TimeInterval
 * @author AxGord <axgord@gmail.com>
 */
abstract TimeInterval(TimeIntervalImpl) {

	public var min(get, never): Time;
	public var max(get, never): Time;
	public var mid(get, never): Time;
	public var back(get, never): Bool;
	public var length(get, never): Time;
	public var minimalPoint(get, never): Time;

	public inline function new(o: TimeIntervalImpl) this = o;
	private inline function get_min(): Time return this.min;
	private inline function get_max(): Time return this.max;

	@:from private static inline function fromInterator(it: IntIterator): TimeInterval
		return create(it.field('min'), it.field('max'));

	@:to public inline function toString(): String return (min: String) + ' ... ' + (max: String);

	@:from private static inline function fromNullString(time: Null<String>): Null<TimeInterval> {
		return time != null ? fromString(time) : null;
	}

	@:from private static function fromString(time: String): TimeInterval {
		var a = time.split('...');
		if (a.length > 1)
			return new TimeInterval( { min: a[0], max: a[1] } );
		else
			return fromTime(a[0]);
	}

	@:from private static inline function fromTime(time: Time): TimeInterval return new TimeInterval( { min: 0, max: time } );
	@:from private static inline function fromUInt(time: UInt): TimeInterval return new TimeInterval( { min: 0, max: time } );
	public inline function check(t: Time): Bool return t >= min && t <= max;
	private inline function get_back(): Bool return min > max;
	private inline function get_length(): Time return max - min;

	public inline function percent(time: Time): Float {
		if (max > min) {
			var t: Float = time - min;
			var m: Float = max - min;
			return t / m;
		} else {
			var t: Float = time - max;
			var m: Float = min - max;
			return t / m;
		}
	}

	private inline function get_minimalPoint(): Time return MathTools.cmin(min.minimalPoint, max.minimalPoint);
	private inline function get_mid(): Time return Math.abs(length) / 2;
	public static inline function create(min: Time, max: Time): TimeInterval return new TimeInterval({ min: min, max: max });

}