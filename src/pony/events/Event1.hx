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
@:nullSafety(Strict) abstract Event1<T1>(Priority<Listener1<T1>>) from Priority<Listener1<T1>> to Priority<Listener1<T1>> {

	public var self(get, never): Event1<T1>;

	@:extern public inline function new(double: Bool = false) {
		this = new Priority(double);
		this.compare = compare;
		this.real = real;
	}

	@:extern private inline function get_self(): Event1<T1> return this;

	private static function real<T1>(l: Listener1<T1>): Bool {
		var e: Null<Priority<Any>> = l.event;
		return e == null || !e.empty;
	}

	private static function compare<T1>(a: Listener1<T1>, b: Listener1<T1>): Bool {
		return switch [a.listener, b.listener] {
			case [LFunction0(a), LFunction0(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LFunction1(a), LFunction1(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LEvent0(a, _), LEvent0(b, _)]:
				a == b;
			case [LEvent1(a, _), LEvent1(b, _)]:
				a == b;
			case [LSub(_, a), LSub(_, b)]:
				a == b;
			case [LNot(_, a), LNot(_, b)]:
				a == b;
			case [LBind1(_, a1), LBind1(_, b1)]:
				a1 == b1;
			case _: false;
		}
	}

	public function dispatch(a1: T1, safe: Bool = false): Void {
		if (this == null || this.isDestroy() || (safe && this.counters.length > 1)) return;
		var controller: SignalControllerInner1<T1> = new SignalControllerInner1<T1>(self);
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
			e.call(a1, controller, safe);
			if (controller.stop) {
				this.brk();
				break;
			}
		}
		this.lock = false;
	}

	@:extern public inline function sub(a1: T1, priority: Int = 0): Event0 {
		var e: Event0 = new Event0();
		(e: Signal0).add(dispatch.bind(a1), priority);
		return e;
	}

	@:extern public inline function subOnce(a1: T1, priority: Int = 0): Event0 {
		var e: Event0 = new Event0();
		(e: Signal0).once(dispatch.bind(a1), priority);
		return e;
	}

	@:op(A - B) @:extern private inline function sub_op(a1: T1): Event0 {
		return sub(a1);
	}

	@:op(A && B) @:extern public inline function and(s: Event1<T1>): Event1<T1> {
		var e: Event1<T1> = new Event1<T1>();
		(e: Signal1<T1>) << self << s;
		return e;
	}

	@:op(A & B) @:extern public inline function andOnce(s: Event1<T1>): Event1<T1> {
		var e: Event1<T1> = new Event1<T1>();
		(e: Signal1<T1>) << self << s << (e: Signal1<T1>).clear;
		return e;
	}

	public inline function destroy(): Void {
		if (this != null) {
			(this: Signal1<T1>).clear();
			this.destroy();
		}
	}
}