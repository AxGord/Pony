package pony.physics;

import pony.Interval;
import pony.Pair;
import pony.physics.Temp;

/**
 * TempInterval
 * @author AxGord <axgord@gmail.com>
 */
abstract TempInterval(Interval<Temp>) from Interval<Temp> to Interval<Temp> {

	public var min(get, never):Temp;
	public var max(get, never):Temp;
	public var mid(get, never):Temp;
	
	inline private function get_min():Temp return this.min;
	inline private function get_max():Temp return this.max;
	inline private function get_mid():Temp return this.mid;
	
	inline public function new(v:Interval<Temp>) this = v;
	
	@:from inline private static function fromStringInterval(it:Interval<String>):TempInterval {
		return new Interval<Temp>(new Pair<Temp, Temp>(it.min == null ? Math.NEGATIVE_INFINITY : it.min, it.max));
	}
	
	@:to inline private function toStringInterval():Interval<String> return new Interval<String>(new Pair<String,String>(min, max));

	@:to inline private function toString():String return toStringInterval();
	
	@:from inline static public function fromString(s:String):TempInterval return Interval.fromString(s);
	
}