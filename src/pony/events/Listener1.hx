package pony.events;

enum Listener1Type<T1> {
	LFunction0( f: Void -> Void );
	LFunction0c( f: SignalController1<T1> -> Void );
	LFunction1( f: T1 -> Void );
	LFunction1c( f: T1 -> SignalController1<T1> -> Void );
	LEvent0( s: Event0, ?safe: Bool );
	LEvent1( s: Event1<T1>, ?safe: Bool );
	LSub( s: Event0, v: T1 );
	LNot( s: Event1<T1>, v: T1 );
	LBind1( s: Event2<T1, Dynamic>, v1: Dynamic );
}

typedef Listener1Impl<T1> = {
	once: Bool,
	listener: Listener1Type<T1>
}

/**
 * Listener1
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
@:forward(once, listener)
@:nullSafety(Strict) abstract Listener1<T1>(Listener1Impl<T1>) to Listener1Impl<T1> from Listener1Impl<T1> {

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function f0<T1>(f: Void -> Void): Listener1<T1>
		return { once: false, listener: LFunction0(f) };

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function f1<T1>(f: T1 -> Void): Listener1<T1>
		return { once: false, listener: LFunction1(f) };

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function f0c<T1>(f: SignalController1<T1> -> Void): Listener1<T1>
		return { once: false, listener: LFunction0c(f) };

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function f0ca<T1>(f: SignalController -> Void): Listener1<T1>
		return { once: false, listener: LFunction0c(cast f) };

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function f1c<T1>(f: T1 -> SignalController1<T1> -> Void): Listener1<T1>
		return { once: false, listener: LFunction1c(f) };

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function f1ca<T1>(f: T1 -> SignalController -> Void): Listener1<T1>
		return { once: false, listener: LFunction1c(cast f) };

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function s0<T1>(f: Event0): Listener1<T1>
		return { once: false, listener: LEvent0(f) };

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function s1<T1>(f: Event1<T1>): Listener1<T1>
		return { once: false, listener: LEvent1(f) };

	public var isEvent(get, never): Bool;
	public var event(get, never): Null<Priority<Any>>;

	public inline function call(a1: T1, controller: SignalController1<T1>, safe: Bool = false): Void switch this.listener {
		case LFunction0(f): f();
		case LFunction0c(f): f(controller);
		case LFunction1(f): f(a1);
		case LFunction1c(f): f(a1, controller);
		case LEvent0(s, sv): s.dispatchWithFlag(sv || safe);
		case LEvent1(s, sv): s.dispatchWithFlag(a1, sv || safe);
		case LSub(s, v) if (v == a1): s.dispatchWithFlag(safe);
		case LNot(s, v) if (v != a1): s.dispatchWithFlag(a1, safe);
		case LBind1(s, v1): s.dispatchWithFlag(a1, v1, safe);
		case _:
	}

	public inline function get_isEvent(): Bool return switch this.listener {
		case LEvent0(_), LEvent1(_), LBind1(_), LSub(_), LNot(_): true;
		case _: false;
	}

	public inline function get_event(): Null<Priority<Any>> return switch this.listener {
		case LEvent0(e): cast e;
		case LEvent1(e): cast e;
		case LBind1(e, _): cast e;
		case LSub(e, _): cast e;
		case LNot(e, _): cast e;
		case _: null;
	}

}