package pony.math;

/**
 * Balance
 * 1% = 0.01
 * @author AxGord <axgord@gmail.com>
 */
abstract Balance(Array<Float>) from Array<Float> {
	
    @:arrayAccess public inline function arrayAccess(key:Int):Float {
        return this[key];
    }
    
    @:arrayAccess public function arrayWrite<T>(key:Int, value:Float):Float {
		if (value > 1) throw 'value can\'t be > 1';
		else if (value == 1) {
			for (i in 0...this.length) if (key != i) this[i] = 0;
			this[key] = value;
		} else {
			var c:Float = value - this[key];
			var na:Array<Float> = [];
			for (i in 0...this.length) {
				if (i == key) {
					na.push(value);
					continue;
				}
				var a:Float = this[i];
				var b:Float = getSum(i, key);
				var x:Float = c * (1 - (1 / (a / b + 1)));
				na.push(this[i] - x);
			}
			for (i in 0...na.length) this[i] = na[i];
		}
		return value;
    }
	
	private function getSum(a:Int, b:Int):Float {
		var sum:Float = 0;
		for (i in 0...this.length)
			if (i != a && i != b)
				sum += this[i];
		return sum;
	}
	
	public function calc(n:Int):Void {
		var s:Float = 1;
		for (i in 0...this.length) if (i != n) s -= this[i];
		this[n] = s;
	}
	
	public inline function iterator():Iterator<Float> return this.iterator();
	
}