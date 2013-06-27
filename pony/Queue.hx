package pony;
import pony.events.Signal;
import pony.magic.Binder;

/**
 * ...
 * @author AxGord
 */

class Queue<T> implements Binder {
	
	@bind public var delay:Int = sl.delay;
	public var begin:Signal;
	//public var progress:Signal;
	public var complite:Signal;
	
	private var sl:SpeedLimit;
	private var dict:Dictionary < T, Void->Void > ;
	private var list:List<T>;
	
	public function new(delay:Int = 0) {
		begin = new Signal();
		complite = new Signal();
		sl = new SpeedLimit(delay);
		dict = new Dictionary < T, Void->Void > ();
		list = new List<T>();
	}
	
	public function add(k:T, f:Void->Void):Void {
		if (!dict.exists(k)) {
			list.push(k);
			if (list.length == 1) {
				begin.dispatch();
				sl.run(tick);
			}
		}
		dict.set(k, f);
	}
	
	private function tick():Void {
		var e:T = list.pop();
		dict.get(e)();
		dict.remove(e);
		if (list.length > 0) sl.run(tick);
		else complite.dispatch();
	}
	
}