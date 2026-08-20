package pony.math;

/**
 * Balance
 * 1% = 0.01
 * @author AxGord <axgord@gmail.com>
 */
abstract Balance(Array<Float>) from Array<Float> {

	@:arrayAccess public inline function arrayAccess(key: Int): Float {
		return this[key];
	}

	public inline function iterator(): Iterator<Float> return this.iterator();

	@:arrayAccess public function arrayWrite<T>(key: Int, value: Float): Float {
		if (value > 1) throw 'value can\'t be > 1';
		if (value == 1) {
			for (i in 0...this.length) if (key != i) this[i] = 0;
			this[key] = value;
		} else {
			final c: Float = value - this[key];
			final na: Array<Float> = [];
			for (i in 0...this.length) {
				if (i == key) {
					na.push(value);
					continue;
				}
				final a: Float = this[i];
				final b: Float = getSum(i, key);
				final x: Float = c * (1 - (1 / (a / b + 1)));
				na.push(this[i] - x);
			}
			for (i in 0...na.length) this[i] = na[i];
		}
		return value;
	}

	public function calc(n: Int): Void {
		var s: Float = 1;
		for (i in 0...this.length) if (i != n) s -= this[i];
		this[n] = s;
	}

	private function getSum(a: Int, b: Int): Float {
		var sum: Float = 0;
		for (i in 0...this.length) if (i != a && i != b) sum += this[i];
		return sum;
	}

}
