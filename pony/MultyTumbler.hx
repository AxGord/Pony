package pony;
import pony.events.Signal;

/**
 * MultyTumbler
 * @author AxGord <axgord@gmail.com>
 */
class MultyTumbler extends Tumbler {

	private var states:Array<Bool>;
	
	public function new(tumblers:Array<Tumbler>, ?on:Array<Signal>, ?off:Array<Signal>, ?defStates:Array<Bool>) {
		super();
		states = [];
		var n:Int = 0;
		if (tumblers != null) {
			for (t in tumblers) {
				t.onEnable.add(setState.bind(n, true));
				t.onDisable.add(setState.bind(n++, false));
				states.push(t.enabled);
			}
		}
		if (on != null) {
			if (defStates == null) defStates = [];
			var i:Int = n;
			for (s in on) {
				s.add(setState.bind(i++, true));
				states.push(defStates.shift());
			}
			var j:Int = n;
			for (s in on) s.add(setState.bind(j++, false));
			if (j != i) throw 'on length != off length ($i, $j)';
		}
	}
	
	private function setState(n:Int, v:Bool):Void {
		states[n] = v;
		enabled = state();
	}
	
	private function state():Bool {
		for (s in states) if (!s) return false;
		return true;
	}
	
}