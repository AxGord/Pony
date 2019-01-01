package pony.math;

/**
 * AutoFormula
 * Not ready
 * @author AxGord <axgord@gmail.com>
 */
class AutoFormula {

	private var values:Map<Float, Float>;
	
	public function new(values:Map<Float,Float>) {
		this.values = values;
	}
	//todo
	/*
	public function get(v:Float):Float {
		var cur:Float;
		var prev:Null<Float> = null;
		var prevKey:Float;
		for (k in values.keys()) {
			cur = values.get(k);
			if (prev == null) {
				if (v <= k) {
					prev = cur;
					prevKey = k;
				}
			} else {
				var rk:Float;
				if (k > prevKey) {
					rk = k - prevKey;
					rk -= 
				} else {
					rk = prevKey - k;
					
				}
				var rv = cur > prev ? cur - prev : prev - cur;
				
			}
		}
	}
	*/
}