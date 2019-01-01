package pony.events;

import haxe.CallStack;
import pony.Priority;

/**
 * Event1
 * @author AxGord <axgord@gmail.com>
 */
@:forward(
	empty,
	onTake,
	onLost
)
abstract Event1<T1>(Priority<Listener1<T1>>) from Priority<Listener1<T1>> to Priority<Listener1<T1>> {

	@:extern inline public function new(double:Bool = false) {
		this = new Priority(double);
		this.compare = compare;
	}
	
	private static function compare<T1>(a:Listener1<T1>, b:Listener1<T1>):Bool {
		return switch [a.listener, b.listener] {
			case [LFunction0(a), LFunction0(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LFunction1(a), LFunction1(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LEvent0(a,_), LEvent0(b,_)]:
				a == b;
			case [LEvent1(a,_), LEvent1(b,_)]:
				a == b;
			case [LSub(_, a), LSub(_, b)]:
				a == b;
			case [LNot(_, a), LNot(_, b)]:
				a == b;
			case [LBind1(_,a1), LBind1(_,b1)]:
				a1 == b1;
			case _: false;
		}
	}
	
	public function dispatch(a1:T1, safe:Bool = false):Bool {
		if (this == null || this.isDestroy() || (safe && this.counters.length > 1)) return false;
		this.lock = true;
		for (e in this) {
			if (this.isDestroy()) return false;
			if (e.once) this.remove(e);
			if (e.call(a1, safe)) {
				this.brk();
				return true;
			}
		}
		this.lock = false;
		return false;
	}
	
	@:extern inline public function sub(a1:T1, priority:Int = 0):Event0 {
		return (new Event0():Signal0).add(dispatch.bind(a1), priority);
	}
	
	@:extern inline public function subOnce(a1:T1, priority:Int = 0):Event0 {
		return cast (new Event0():Signal0).once(dispatch.bind(a1), priority);
	}
	
	@:op(A - B) @:extern inline private function sub_op(a1:T1):Event0 {
		return sub(a1);
	}
	
	@:op(A && B) @:extern inline public function and(s:Event1<T1>):Event1<T1> {
		return (new Event1():Signal1<T1>).add(this).add(s);
	}
	
	@:op(A & B) @:extern inline public function andOnce(s:Event1<T1>):Event1<T1> {
		return (new Event1():Signal1<T1>).add(this).add(s);
	}
	
	inline public function destroy():Void {
		if (this != null) this.destroy();
	}
}