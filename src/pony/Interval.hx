package pony;

import pony.math.MathTools;

using Reflect;

/**
 * Interval
 * @author AxGord <axgord@gmail.com>
 */
abstract Interval<T:Dynamic>(Pair<T, T>) {

	public var min(get, never): T;
	public var max(get, never): T;
	public var mid(get, never): Float;
	public var range(get, never): Float;

	public inline function new(p: Pair<T, T>) this = p;

	private inline function get_min(): T return this.a;

	private inline function get_max(): T return this.b;

	private inline function get_mid(): Float return (min: Float) == Math.NEGATIVE_INFINITY ? max : (min: Float) + Math.abs(max - min) / 2;

	private inline function get_range(): Float return MathTools.range(min, max);

	@:to public inline function toString(): String return '$min ... $max';

	public inline function includes(v: T): Bool return (v: Float) >= (min: Float) && (v: Float) <= (max: Float);

	@:to private inline function toPair(): Pair<T, T> return this;

	public static inline function create<V>(min: V, max: V): Interval<V> return new Pair<V, V>(min, max);

	@:from public static inline function fromString(s: String): Interval<String> {
		final a = s.split('...');
		return a.length > 1 ? create(StringTools.trim(a[0]), StringTools.trim(a[1])) : create(null, StringTools.trim(a[0]));
	}

	@:from private static inline function fromPair<V>(p: Pair<V, V>): Interval<V> return new Interval<V>(p);

	@:from private static inline function fromInterator(it: IntIterator): Interval<Int> return create(it.field('min'), it.field('max'));

	@:from private static inline function fromInteratorF(it: IntIterator): Interval<Float> return create(it.field('min'), it.field('max'));

}
