package pony.math;

import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

using pony.math.MathTools;

/**
 * Smooth
 * @author AxGord <axgord@gmail.com>
 */
class Smooth implements HasSignal {

	@:auto public var onUpdate: Signal1<Float>;

	public var value(default, null): Null<Float> = null;
	public var time: Float;
	private var vals: Array<Float>;
	private var dtsum: Float;
	private var last: Null<Float>;

	public function new(time: Float = 0.5) {
		this.time = time;
		dtsum = 0;
		vals = [];
		DeltaTime.update.add(tick);
	}

	public function set(v: Float): Void {
		if (value == null) {
			value = v;
			eUpdate.dispatch(value);
		}
		vals.push(v);
		last = v;
	}

	private function tick(dt: Float): Void {
		dtsum += dt;
		if (dtsum < time) return;
		dtsum %= time;
		if (vals.length == 0) {
			if (last != null) {
				value = last;
				eUpdate.dispatch(value);
				last = null;
			}
			return;
		}
		value = vals.arithmeticMean();
		vals = [];
		eUpdate.dispatch(value);
	}

	public function reset(): Void {
		vals = [];
		value = 0;
		eUpdate.dispatch(value);
	}

}