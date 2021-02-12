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
@:nullSafety(Strict) abstract Event0(Priority<Listener0>) from Priority<Listener0> to Priority<Listener0> {

	public var self(get, never): Event0;

	@:extern public inline function new(double: Bool = false) {
		this = new Priority(double);
		this.compare = compare;
		this.real = real;
	}

	@:extern private inline function get_self(): Event0 return this;

	private static function real(l: Listener0): Bool {
		var e: Null<Priority<Any>> = l.event;
		return e == null || !e.empty;
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
		var controller: SignalControllerInner0 = new SignalControllerInner0(self);
		this.lock = true;
		for (e in this) {
			if (this.isDestroy()) return;
			if (e.once) {
				var ev: Null<Priority<Any>> = e.event;
				if (ev != null) {
					ev.onLost >> this.changeReals;
					ev.onTake >> this.changeReals;
				}
				this.remove(e);
			}
			e.call(controller, safe);
			if (controller.stop) {
				this.brk();
				break;
			}
		}
		this.lock = false;
	}

	@:op(A && B) @:extern public inline function and(s: Event0): Event0 {
		var e: Event0 = new Event0();
		(e: Signal0) << self << s;
		return e;
	}

	@:op(A & B) @:extern public inline function andOnce(s: Event0): Event0 {
		var e: Event0 = new Event0();
		(e: Signal0) << self << s << (e: Signal0).clear;
		return e;
	}

	public inline function destroy(): Void {
		if (this != null) this.destroy();
	}

}