package pony.time;

import pony.math.MathTools;

using Reflect;

private typedef TimeInterval_ = { min:Time, max:Time };

/**
 * TimeInterval
 * @author AxGord <axgord@gmail.com>
 */
abstract TimeInterval(TimeInterval_) {
	
	public var min(get, never):Time;
	public var max(get, never):Time;
	public var mid(get, never):Time;
	public var back(get, never):Bool;
	public var length(get, never):Time;
	public var minimalPoint(get, never):Time;

	inline public function new(o:TimeInterval_) this = o;
	
	inline private function get_min():Time return this.min;
	inline private function get_max():Time return this.max;
	
	@:from inline private static function fromInterator(it:IntIterator):TimeInterval
		return create(it.field('min'), it.field('max'));
	
	@:to inline public function toString():String return (min:String) + ' ... ' + (max:String);
	
	@:from private static function fromString(time:String):TimeInterval {
		var a = time.split('...');
		if (a.length > 1)
			return new TimeInterval( { min: a[0], max: a[1] } );
		else
			return fromTime(a[0]);
	}
	
	@:from inline private static function fromTime(time:Time):TimeInterval return new TimeInterval( { min: 0, max: time } );
	
	inline public function check(t:Time):Bool return t >= min && t <= max;
		
	inline private function get_back():Bool return min > max;
	inline private function get_length():Time return max - min;
	
	inline public function percent(time:Time):Float {
		if (max > min) {
			var t:Float = time - min;
			var m:Float = max - min;
			return t / m;
		} else {
			var t:Float = time - max;
			var m:Float = min - max;
			return t / m;
		}
	}
	
	inline private function get_minimalPoint():Time return MathTools.cmin(min.minimalPoint, max.minimalPoint);
	
	inline private function get_mid():Time return Math.abs(max - min) / 2;
	
	inline public static function create(min:Time, max:Time):TimeInterval return new TimeInterval( { min:min, max:max });
}