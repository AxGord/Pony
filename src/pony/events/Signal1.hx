package pony.events;

import haxe.Log;
import haxe.PosInfos;
import pony.Priority;
import pony.events.Listener1;

/**
 * Signal1
 * @author AxGord <axgord@gmail.com>
 */
@:forward(
	empty,
	min,
	max,
	change,
	getPriority,
	exists,
	existsArray
)
@:nullSafety(Strict) abstract Signal1<T1>(Priority<Listener1<T1>>) from Event1<T1> from Priority<Listener1<T1>> {

	public function add(e: Listener1<T1>, priority: Int = 0): Signal1<T1> {
		var ev: Null<Priority<Any>> = e.event;
		if (ev != null) {
			@:privateAccess ev.onLost.directAdd(this.changeReals);
			@:privateAccess ev.onTake.directAdd(this.changeReals);
		}
		return this.add(e, priority);
	}

	private inline function directAdd(e: Listener1<T1>): Signal1<T1> return this.add(e);

	public function remove(e: Listener1<T1>): Bool {
		unlistenSubChange(e);
		return this.remove(e);
	}

	private inline function directRemove(e: Listener1<T1>): Bool return this.remove(e);

	public inline function clear(): Signal1<T1> {
		for (e in this.data) unlistenSubChange(e);
		return this.clear();
	}

	private inline function unlistenSubChange(l: Listener1<T1>): Void {
		var e: Null<Priority<Any>> = l.event;
		if (e != null) {
			@:privateAccess e.onLost.directRemove(this.changeReals);
			@:privateAccess e.onTake.directRemove(this.changeReals);
		}
	}

	@:extern public inline function once(e: Listener1<T1>, priority: Int = 0): Signal1<T1> {
		e.once = true;
		return add(e, priority);
	}

	@:op(A << B) @:extern private inline function op_add(listener: Listener1<T1>): Signal1<T1> return add(listener);
	@:op(A < B) @:extern private inline function once_op(listener: Listener1<T1>): Signal1<T1> return once(listener);
	@:op(A >> B) @:extern private inline function remove_op(listener: Listener1<T1>): Bool return remove(listener);

	public function sub(a1: T1, priority: Int = 0, once: Bool = false): Signal0 {
		for (e in this) switch e.listener {
			case LSub(sig, val) if (val == a1):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event0();
		add({ once: once, listener: LSub(s, a1) }, priority);
		return s;
	}

	@:op(A - B) @:extern private inline function sub_op(a1: T1): Signal0 {
		return sub(a1);
	}

	@:op(A -= B) @:extern public inline function removeSub(a1: T1): Bool {
		return this.remove({ once: false, listener: LSub(cast null, a1) });
	}

	public function bind1<T2>(a1: T2, priority: Int = 0, _once: Bool = false): Signal2<T1, T2> {
		for (e in this) switch e.listener {
			case LBind1(sig, val) if (val == a1):
				this.brk();
				return cast sig;
			case _:
		}
		var s = new Event2();
		add({ once: _once, listener: LBind1(s, a1) }, priority);
		return s;
	}

	@:op(A + B) @:extern private inline function bind1_op<T2>(a1: T2): Signal2<T1, T2> {
		return bind1(a1);
	}

	@:op(A * B) @:extern private inline function bind1Once_op<T2>(a1: T2): Signal2<T1, T2> {
		return bind1(a1, 0, true);
	}

	public function not(a1: T1, priority: Int = 0, once: Bool = false): Signal1<T1> {
		for (e in this) switch e.listener {
			case LNot(sig, val) if (val == a1):
				this.brk();
				return sig;
			case _:
		}
		var s = new Event1();
		add({ once: once, listener: LNot(s, a1) }, priority);
		return s;
	}

	@:op(A / B) @:extern private inline function not_op(a1: T1): Signal1<T1> {
		return not(a1);
	}

	@:op(A % B) @:extern private inline function not_op0(a1: T1): Signal0 {
		return not(a1);
	}

	@:op(A /= B) @:extern public inline function removeNot(a1: T1): Bool {
		return this.remove({ once: false, listener: LNot(cast null, a1) });
	}

	@:from @:extern private static inline function signal2<T1, T2>(s: Signal2<T1, T2>): Signal1<T1> {
		return cast s;
	}

	@:op(A || B) @:extern public inline function or(s: Signal1<T1>): Signal1<T1> {
		var ns = new Event1();
		add(ns);
		s.add(ns);
		return ns;
	}

	@:op(A | B) @:extern public inline function orOnce(s: Signal1<T1>): Signal1<T1> {
		var ns = new Event1();
		once(ns);
		s.once(ns);
		return ns;
	}

	@:op(A & B) public function andOnce<T2>(s: Signal1<T2>): Signal2<T1, T2> {
		var ns = new Event2<T1, T2>();
		var listener1: Listener1<T1> = cast null;
		var listener2: Listener1<T2> = cast null;
		listener1 = function(a) {
			s.remove(listener2);
			s.once(ns.dispatch.bind(a));
		}
		listener2 = function(b) {
			remove(listener1);
			once(ns.dispatch.bind(_, b));
		}
		once(listener1);
		s.once(listener2);
		return ns;
	}

	@:op(A && B) public function and<T2>(s: Signal1<T2>): Signal2<T1, T2> {
		var ns = new Event2<T1, T2>();
		var start: Void -> Void = cast null;
		var listener1: Listener1<T1> = cast null;
		var listener2: Listener1<T2> = cast null;
		listener1 = function(a) {
			s.remove(listener2);
			s.once(ns.dispatch.bind(a));
			s.once(start);
		}
		listener2 = function(b) {
			remove(listener1);
			once(ns.dispatch.bind(_, b));
			once(start);
		}
		start = function () {
			once(listener1);
			s.once(listener2);
		}
		start();
		return ns;
	}

	@:extern public inline function convert0(f: Event0 -> T1 -> Void): Signal0 {
		var ns = new Event0();
		add(f.bind(ns));
		return ns;
	}

	@:extern public inline function convert1<ST1>(f: Event1<ST1> -> T1 -> Void): Signal1<ST1> {
		var ns = new Event1();
		add(f.bind(ns));
		return ns;
	}

	@:extern public inline function convert2<ST1, ST2>(f: Event2<ST1, ST2> -> T1 -> Void): Signal2<ST1, ST2> {
		var ns = new Event2();
		add(f.bind(ns));
		return ns;
	}

	@:extern public inline function join(s: Signal1<T1>): Signal1<T1> {
		add({ once: false, listener: LEvent1((untyped s: Event1<T1>), true) });
		s.add({ once: false, listener: LEvent1((this: Event1<T1>), true) });
		return this;
	}

	@:extern public inline function unjoin(s: Signal1<T1>): Signal1<T1> {
		remove((untyped s: Event1<T1>));
		s.remove((this: Event1<T1>));
		return this;
	}

	@:extern public inline function trace(?message: String, priority: Int = 0, ?pos: PosInfos): Void {
		this.add(function() Log.trace(message, pos), priority);
	}

}