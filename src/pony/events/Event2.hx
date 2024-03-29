package pony.events;

import pony.Priority;

/**
 * Event2
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:forward(
	empty,
	#if pony_experimental changeEmpty, #end
	onTake,
	onLost
)
@:access(pony.events.Listener1)
abstract Event2<T1, T2>(Priority<Listener2<T1, T2>>) from Priority<Listener2<T1, T2>> to Priority<Listener2<T1, T2>> {

	public var self(get, never): Event2<T1, T2>;

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function new(double: Bool = false) {
		this = new Priority(double);
		this.compare = compare;
		this.real = real;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_self(): Event2<T1, T2> return this;

	private static function real<T1, T2>(l: Listener2<T1, T2>): Bool {
		var e: Null<Priority<Any>> = l.event;
		return e == null || !e.empty;
	}

	private static function compare<T1, T2>(a: Listener2<T1, T2>, b: Listener2<T1, T2>): Bool {
		return switch [a.listener, b.listener] {
			case [LFunction0(a), LFunction0(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LFunction1(a), LFunction1(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LFunction2(a), LFunction2(b)]:
				SignalTools.functionHashCompare(a, b);
			case [LEvent0(a, _), LEvent0(b, _)]:
				a == b;
			case [LEvent1(a, _), LEvent1(b, _)]:
				a == b;
			case [LEvent2(a, _), LEvent2(b, _)]:
				a == b;
			case [LSub(_, a1, a2), LSub(_, b1, b2)]:
				a1 == b1 && a2 == b2;
			case [LSub1(_, a), LSub1(_, b)]:
				a == b;
			case [LSub2(_, a), LSub2(_, b)]:
				a == b;
			case [LNot(_, a1, a2), LNot(_, b1, b2)]:
				a1 == b1 && a2 == b2;
			case [LNot1(_, a), LNot1(_, b)]:
				a == b;
			case [LNot2(_, a), LNot2(_, b)]:
				a == b;
			case _: false;
		}
	}

	@:op(a()) public inline function dispatch(a1: T1, a2: T2): Void dispatchWithFlag(a1, a2, false);
	public inline function saveDispatch(a1: T1, a2: T2): Void dispatchWithFlag(a1, a2, true);

	public function dispatchWithFlag(a1: T1, a2: T2, safe: Bool): Void {
		if (this == null || this.isDestroy() || (safe && this.counters.length > 1)) return;
		var controller: SignalControllerInner2<T1, T2> = new SignalControllerInner2<T1, T2>(self);
		this.lock = true;
		for (e in this) {
			if (this.isDestroy()) return;
			if (e.once) this.remove(e);
			e.call(a1, a2, controller, safe);
			if (controller.stop) {
				this.brk();
				break;
			}
		}
		this.lock = false;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function sub(a1: T1, a2: T2, priority: Int = 0): Event0 {
		var e: Event0 = new Event0();
		(e: Signal0).add(dispatch.bind(a1, a2), priority);
		return e;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function subOnce(a1: T1, a2: T2, priority: Int = 0): Event0 {
		var e: Event0 = new Event0();
		(e: Signal0).once(dispatch.bind(a1, a2), priority);
		return e;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function sub1(a1: T1, priority: Int = 0): Event1<T2> {
		var e: Event1<T2> = new Event1<T2>();
		(e: Signal1<T2>).add(Listener1.f1(dispatch.bind(a1)), priority);
		return e;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function sub1Once(a1: T1, priority: Int = 0): Event1<T2> {
		var e: Event1<T2> = new Event1<T2>();
		(e: Signal1<T2>).once(Listener1.f1(dispatch.bind(a1)), priority);
		return e;
	}

	@:op(A - B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function sub1_op(a1: T1): Event1<T2> {
		return sub1(a1);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function sub2(a2:T2, priority:Int = 0): Event1<T1> {
		var e: Event1<T1> = new Event1<T1>();
		(e: Signal1<T1>).add(Listener1.f1(dispatch.bind(_, a2)), priority);
		return e;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function sub2Once(a2: T2, priority: Int = 0): Event1<T1> {
		return cast (new Event1(): Signal1<T1>).once(dispatch.bind(_, a2), priority);
	}

	@:op(A && B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function and(s: Event2<T1, T2>): Event2<T1, T2> {
		var e: Event2<T1, T2> = new Event2<T1, T2>();
		(e: Signal2<T1, T2>) << self << s;
		return e;
	}

	@:op(A & B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function andOnce(s: Event2<T1, T2>): Event2<T1, T2> {
		var e: Event2<T1, T2> = new Event2<T1, T2>();
		(e: Signal2<T1, T2>) << self << s << (e: Signal2<T1, T2>).clear;
		return e;
	}

	public inline function destroy(): Void {
		if (this != null) {
			(this: Signal2<T1, T2>).clear();
			this.destroy();
		}
	}

}