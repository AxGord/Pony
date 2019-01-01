package pony.math;

import pony.events.Signal;

using pony.Tools;

/**
 * Smooth
 * @author AxGord <axgord@gmail.com>
 */
class Smooth {

	public var value(default, null):Null<Float> = null;
	public var time:Float;
	public var update(default, null):Signal;
	private var vals:Array<Float>;
	private var dtsum:Float;
	private var last:Null<Float>;
	
	public function new(time:Float = 0.5) {
		this.time = time;
		dtsum = 0;
		vals = [];
		update = new Signal();
		DeltaTime.update.add(tick);
	}
	
	public function set(v:Float):Void {
		if (value == null) {
			value = v;
			update.dispatch(value);
		}
		vals.push(v);
		last = v;
	}
	
	private function tick(dt:Float):Void {
		dtsum += dt;
		if (dtsum < time) return;
		dtsum %= time;
		if (vals.length == 0) {
			if (last != null) {
				value = last;
				update.dispatch(value);
				last = null;
			}
			return;
		}
		value = vals.arithmeticMean();
		vals = [];
		update.dispatch(value);
	}
	
	public function reset():Void
	{
		vals = [];
		value = 0;
		update.dispatch(value);
	}
	
	
}