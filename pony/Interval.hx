package pony;

import pony.math.MathTools;

using Reflect;

/**
 * Interval
 * @author AxGord <axgord@gmail.com>
 */
abstract Interval<T:Dynamic>(Pair<T,T>) {

	public var min(get, never):T;
	public var max(get, never):T;
	public var mid(get, never):Float;
	public var range(get, never):Float;
	
	inline public function new(p:Pair<T, T>) this = p;
	inline private function get_min():T return this.a;
	inline private function get_max():T return this.b;
	inline private function get_mid():Float return (min:Float) == Math.NEGATIVE_INFINITY ? max : (min:Float) + Math.abs(max - min) / 2;
	inline private function get_range():Float return MathTools.range(min, max);
	
	@:from inline static private function fromPair<V>(p:Pair<V,V>):Interval<V> return new Interval<V>(p);
	@:to inline private function toPair():Pair<T,T> return this;
	
	inline public static function create<V>(min:V, max:V):Interval<V> return new Pair<V,V>(min, max);
	
	@:from inline static public function fromString(s:String):Interval<String> {
		var a = s.split('...');
		if (a.length > 1)
			return create(StringTools.trim(a[0]), StringTools.trim(a[1]));
		else
			return create(null, StringTools.trim(a[0]));
	}
	
	@:to inline public function toString():String return min + ' ... ' + max;
	
	@:from inline private static function fromInterator(it:IntIterator):Interval<Int> return create(it.field('min'), it.field('max'));
	@:from inline private static function fromInteratorF(it:IntIterator):Interval<Float> return create(it.field('min'), it.field('max'));
	
	inline public function includes(v:T):Bool return (v:Float) >= (min:Float) && (v:Float) <= (max:Float);
	
}