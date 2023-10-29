package pony.events;

import haxe.Log;
import haxe.PosInfos;
import pony.Priority;
import pony.events.Listener0;

/**
 * Signal0
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:forward(
	empty,
	min,
	max,
	change,
	getPriority,
	exists,
	existsArray
)
@:access(pony.events.Listener0)
@:nullSafety(Strict) abstract Signal0(Priority<Listener0>) from Event0 from Priority<Listener0> {

	public function add(e: Listener0, priority: Int = 0): Signal0 {
		var ev: Null<Priority<Any>> = e.event;
		if (ev != null) {
			ev.onLost.directAdd(this.changeReals);
			ev.onTake.directAdd(this.changeReals);
		}
		return this.add(e, priority);
	}

	private inline function directAdd(e: Listener0): Signal0 return this.add(e);

	public function remove(e: Listener0): Bool {
		unlistenSubChange(e);
		return this.remove(e);
	}

	private inline function directRemove(e: Listener0): Bool return this.remove(e);

	public inline function clear(): Signal0 {
		for (e in this.data) unlistenSubChange(e);
		return this.clear();
	}

	private inline function unlistenSubChange(l: Listener0): Void {
		var e: Null<Priority<Any>> = l.event;
		if (e != null) {
			@:privateAccess e.onLost.directRemove(this.changeReals);
			@:privateAccess e.onTake.directRemove(this.changeReals);
		}
	}

	@:op(A >> B) #if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function remove_op(e: Listener0): Signal0 {
		remove(e);
		return this;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function once(e: Listener0, priority: Int = 0): Signal0 {
		e.once = true;
		return add(e, priority);
	}

	@:op(A << B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function add_op(listener: Listener0): Signal0 return add(listener);

	@:op(A < B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function once_op(e: Listener0): Signal0 return once(e);

	@:op(A || B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function or(s: Signal0): Signal0 {
		var ns = new Event0();
		add(ns);
		s.add(ns);
		return ns;
	}

	@:op(A | B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function orOnce(s: Signal0): Signal0 {
		var ns = new Event0();
		once(ns);
		s.once(ns);
		return ns;
	}

	@:op(A & B) public function andOnce(s: Signal0): Signal0 {
		var ns = new Event0();
		var listener1: Listener0 = cast null;
		var listener2: Listener0 = cast null;
		listener1 = Listener0.f0(function() {
			s.remove(listener2);
			s.once(ns);
		});
		listener2 = Listener0.f0(function() {
			this.remove(listener1);
			once(ns);
		});
		once(listener1);
		s.once(listener2);
		return ns;
	}

	@:op(A && B) public function and(s: Signal0): Signal0 {
		var ns = new Event0();
		var start: Listener0 = cast null;
		var listener1: Listener0 = cast null;
		var listener2: Listener0 = cast null;
		listener1 = function() {
			s.remove(listener2);
			s.once(ns);
			s.once(start);
		}
		listener2 = function() {
			this.remove(listener1);
			once(ns);
			once(start);
		}
		start = function() {
			once(listener1);
			s.once(listener2);
		}
		var c: SignalControllerInner0 = new SignalControllerInner0(this);
		start.call(c, false);
		return ns;
	}

	public function bind1<T1>(a1: T1, priority: Null<Int> = 0, _once: Bool = false): Signal1<T1> {
		for (e in this) switch e.listener {
			case LBind1(sig, val) if (val == a1):
				this.brk();
				return cast sig;
			case _:
		}
		var s = new Event1();
		this.add({ once: _once, listener: LBind1(s, a1) }, priority);
		return s;
	}

	@:op(A + B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function bind1_op<T1>(a1: T1): Signal1<T1> {
		return bind1(a1);
	}

	@:op(A * B)
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function bind1Once_op<T1>(a1: T1): Signal1<T1> {
		return bind1(a1, true);
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function removeBind1<T1>(a1: T1): Bool {
		return this.remove({ once: false, listener: LBind1(cast null, a1) });
	}

	public function bind2<T1, T2>(a1: T1, a2: T2, priority: Int = 0, _once: Bool = false): Signal2<T1, T2> {
		for (e in this) switch e.listener {
			case LBind2(sig, v1, v2) if (v1 == a1 && v2 == a2):
				this.brk();
				return cast sig;
			case _:
		}
		var s = new Event2();
		add({ once: _once, listener: LBind2(s, a1, a2) }, priority);
		return s;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function removeBind2<T1, T2>(a1: T1, a2: T2): Bool {
		return this.remove({ once: false, listener: LBind2(cast null, a1, a2) });
	}

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function fromSignal1<T1>(s: Signal1<T1>): Signal0 {
		var ns = new Event0();
		s.add(ns);
		return ns;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function convert0(f: Event0 -> Void): Signal0 {
		var ns = new Event0();
		add(Listener0.f0(f.bind(ns)));
		return ns;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function convert1<ST1>(f: Event1<ST1> -> Void): Signal1<ST1> {
		var ns = new Event1();
		add(Listener0.f0(f.bind(ns)));
		return ns;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function convert2<ST1, ST2>(f: Event2<ST1, ST2> -> Void): Signal2<ST1, ST2> {
		var ns = new Event2();
		add(Listener0.f0(f.bind(ns)));
		return ns;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function join(s: Signal0): Signal0 {
		add({ once: false, listener: LEvent0((untyped s:Event0), true) });
		s.add({ once: false, listener: LEvent0((this: Event0), true) });
		return this;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function unjoin(s: Signal0): Signal0 {
		remove((untyped s: Event0));
		s.remove((this: Event0));
		return this;
	}

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function trace(?message: String, priority: Int = 0, ?pos: PosInfos): Void {
		this.add(Listener0.f0(function() Log.trace(message, pos)), priority);
	}

}