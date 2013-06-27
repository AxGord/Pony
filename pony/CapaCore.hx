package pony;
import pony.magic.Declarator;

/**
 * Capacitys system
 * -1 - infinity
 * @author AxGord
 */

typedef Capacity<T> = {
	total:Int,
	current:Int,
	buffer:Array<{count: Int, type: T}>,
	bufferSize:Int,
	type:T,
	to: Array<{id:String, speed: Int}>,
	mod: Array<{ speed: Int, type: T }>
}

class CapaCore<T> implements Declarator {

	@arg public var capacitys:Dynamic<Capacity<T>>;
	private var revert:Bool = false;
	
	public function step():Void {
		zeropush();
		for (id in Reflect.fields(capacitys)) {
			var cap:Capacity<T> = get(id);
			if (cap.buffer.length > 0) {
				shifter(cap);
			}
		}
		var fs:Array<String> = Reflect.fields(capacitys);
		if (revert) fs.reverse();
		revert = !revert;
		for (id in fs) {
			var cfrom:Capacity<T> = get(id);
			for (mod in cfrom.mod) {
				if (cfrom.type == null) {
					var d:Dynamic = { };
					for (f in Reflect.fields(mod.type)) {
						var val:Int = cast(Reflect.field(mod.type, f), Int) * mod.speed;
						if (val < 0) val = 0;
						Reflect.setField(d, f, val);
					}
					cfrom.type = d;
				} else
					for (f in Reflect.fields(mod.type)) {
						var val:Int = Reflect.field(cfrom.type, f) + cast(Reflect.field(mod.type, f), Int) * mod.speed;
						if (val < 0) val = 0;
						Reflect.setField(cfrom.type, f, val);
					}
			}
			
			if (cfrom.current > 0 || cfrom.total == -1) for (rc in cfrom.to) if (rc.speed > 0) {
				var cto:Capacity<T> = get(rc.id);
				if (cto.total == -1 || currentSum(cto) != cto.total) {
					var sp:Int = cfrom.total == -1 || rc.speed < cfrom.current ? rc.speed : cfrom.current;
					if (cto.total != -1 && currentSum(cto) + sp > cto.total) {
						var d:Int = sp - currentSum(cto);
						if (d <= 0) continue;
						cto.buffer.push({count: d, type: cfrom.type});
						if (cfrom.total == -1) continue;
						if (cfrom.current >= d) {
							cfrom.current -= d;
						} else
							cfrom.current = 0;
					} else {
						if (cto.total != -1)
							cto.buffer.push({count: sp, type: cfrom.type});
						if (cfrom.total == -1) continue;
						if (cfrom.current >= sp)
							cfrom.current -= sp;
						else
							cfrom.current = 0;
					}
				}
			}
		}
		zeropush();
	}
	
	private function shifter(cap:Capacity<T>):Void {
		var v = cap.buffer.shift();
		if (v == null) return;
		if (cap.type != null) for (f in Reflect.fields(v.type)) {
			var c1:Int = cap.current;
			var c2:Int = v.count;
			var a:Int = Math.ceil(Reflect.field(cap.type, f)/1);
			var b:Int = Math.ceil(Reflect.field(v.type, f) / 1);
			var val:Float = (c1 * a + c2 * b) / (c1 + c2);
			Reflect.setField(cap.type, f, a < b ? Math.ceil(val) : Math.floor(val));
		} else {
			var d:Dynamic = { };
			for (f in Reflect.fields(v.type)) {
				var c1:Int = cap.current;
				var c2:Int = v.count;
				var a:Int = 0;
				var b:Int = Math.ceil(Reflect.field(v.type, f) / 1);
				var val:Float = (c1 * a + c2 * b) / (c1 + c2);
				Reflect.setField(d, f, a < b ? Math.ceil(val) : Math.floor(val));
			}
			cap.type = d;
		}
		cap.current += v.count;
	}
	
	private function zeropush():Void {
		for (id in Reflect.fields(capacitys)) {
			var cap:Capacity<T> = get(id);
			var b:Int = Math.ceil(cap.bufferSize * (1-caprocent(cap)));
			if (cap.buffer.length > b) {
				var d:Int = cap.buffer.length - b;
				var i:Int = cap.buffer.length;
				while (--i > 0 && d > 0) {
					if (cap.buffer[i] == null) {
						cap.buffer.splice(i, 1);
						d--;
					}
				}
				if (d > 0)
					shifter(cap);
					
			} else for (null in cap.buffer.length...b)
				cap.buffer.push(null);
		}
	}
	
	public function isActive(id:String, n:Int = 0):Bool {
		var cfrom:Capacity<T> = get(id);
		var recap = cfrom.to[n];
		var cto:Capacity<T> = get(recap.id);
		
		if (recap.speed == 0) return false;
		//cto full
		if (cto.total != -1 && cto.current == cto.total) return false;
		if (cfrom.total != -1 && cfrom.current == 0) return false;
		
		return true;
	}
	
	public static function currentSum(cap:Capacity<Dynamic>):Int {
		var s:Int = cap.current;
		for (b in cap.buffer)
			if (b != null)
				s += b.count;
		return s;
	}
	
	//private static inline function caprocent(c:Capacity):Float return c.current/c.total
	private static inline function caprocent(c:Capacity<Dynamic>):Float return currentSum(c) / c.total
	
	public inline function get(id:String):Capacity<T> return Reflect.field(capacitys, id)
	
	public function iterator():Iterator<String> return Reflect.fields(capacitys).iterator()
	
	public function canGet(id:String, to:Int):Int {
		var c:Capacity<T> = get(id);
		var sp:Int = c.to[to].speed;
		return c.total == -1 || sp < c.current ? sp : c.current;
	}
}