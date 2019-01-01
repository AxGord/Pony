package pony.math;

import pony.magic.Declarator;
import pony.time.DeltaTime;

/**
 * Liker
 * @author AxGord <axgord@gmail.com>
 */
class Liker implements Declarator {

	@:arg private var base:Array<Array<Float>>;
	@:arg public var min:Float = 1;
	@:arg public var max:Float = 1;
	
	public function like(data:Array<Float>):Int {
		var id:Int = -1;
		var k:Float = 0;
		for (i in 0...base.length) {
			var r:Float = likek(base[i], data);
			if (r > k) {
				id = i;
				k = r;
			}
		}
		return id;
	}
	
	public function likeAsync(data:Array<Float>, ok:Int->Void, ?error:Dynamic->Void):Void {
		var id:Int = -1;
		var k:Float = 0;
		var i:Int = 0;
		var f:Void->Void = null;
		f = function() {
			try {
				var r:Float = likek(base[i], data);
				if (r > k) {
					id = i;
					k = r;
				}
				i++;
			} catch (e:Dynamic) {
				if (error == null) throw e;
				else error(e);
			}
			if (i >= base.length) {
				ok(id);
				DeltaTime.fixedUpdate.remove(f);
			}
		};
		DeltaTime.fixedUpdate.add(f);
	}
	
	public function likek(base:Array<Float>, data:Array<Float>):Float {
		if (base.length != data.length) throw 'data != base data';
		var k:Float = 0;
		for (i in 0...data.length) {
			var a = data[i];
			var b = base[i];
			if (a == b) {
				k += 1;
			} else if (a > b) {
				var r = a - b;
				if (r < max)
					k += 1 - r / max;
				else
					return 0;
			} else if (a < b) {
				var r = b - a;
				if (r < min)
					k += 1 - r / min;
				else
					return 0;
			}
		}
		return k;
	}
	
}