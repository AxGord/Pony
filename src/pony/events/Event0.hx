package pony.events;

import pony.Priority;

/**
 * Event0
 * @author AxGord <axgord@gmail.com>
 */
@:forward(
	empty,
	onTake,
	onLost
)
abstract Event0(Priority<Listener0>) from Priority<Listener0> to Priority<Listener0> {

	@:extern public inline function new(double: Bool = false) {
		this = new Priority(double);
		this.compare = compare;
	}

	private static function compare<T1>(a: Listener0, b: Listener0): Bool {
		return switch [a.listener, b.listener] {
			case [LFunction0(a), LFunction0(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LEvent0(a, _), LEvent0(b, _)]:
				a == b;
			case [LBind1(_, a), LBind1(_, b)]:
				a == b;
			case [LBind2(_, a1, a2), LBind2(_, b1, b2)]:
				a1 == b1 && a2 == b2;
			case _: false;
		}
	}

	public function dispatch(safe: Bool = false): Void {
		if (this == null || this.isDestroy() || (safe && this.counters.length > 1)) return;
		var controller: SignalControllerInner0 = new SignalControllerInner0(this);
		this.lock = true;
		for (e in this) {
			if (this.isDestroy()) return;
			if (e.once) this.remove(e);
			e.call(controller, safe);
			if (controller.stop) {
				this.brk();
				break;
			}
		}
		this.lock = false;
	}

	@:op(A && B) @:extern public inline function and(s: Event0): Event0 {
		return (new Event0(): Signal0).add(this).add(s);
	}

	@:op(A & B) @:extern public inline function andOnce(s: Event0): Event0 {
		return (new Event0(): Signal0).add(this).add(s);
	}

	public inline function destroy(): Void {
		if (this != null) this.destroy();
	}

}