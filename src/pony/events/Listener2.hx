package pony.events;

enum Listener2Type<T1, T2> {
	LFunction0( f: Void -> Void );
	LFunction0c( f: SignalController2<T1, T2> -> Void );
	LFunction1( f: T1 -> Void );
	LFunction1c( f: T1 -> SignalController2<T1, T2> -> Void );
	LFunction2( f: T1 -> T2 -> Void );
	LFunction2c( f: T1 -> T2 -> SignalController2<T1, T2> -> Void );
	LEvent0( s: Event0, ?safe: Bool );
	LEvent1( s: Event1<T1>, ?safe: Bool );
	LEvent2( s: Event2<T1, T2>, ?safe: Bool );
	LSub( s: Event0, v1: T1, v2: T2 );
	LSub1( s: Event1<T2>, v: T1 );
	LSub2( s: Event1<T1>, v: T2 );
	LNot( s: Event2<T1, T2>, v1: T1, v2: T2 );
	LNot1( s: Event2<T1, T2>, v: T1 );
	LNot2( s: Event2<T1, T2>, v: T2 );
}

typedef Listener2Impl<T1, T2> = {
	once: Bool,
	listener: Listener2Type<T1, T2>
}

/**
 * Listener2
 * @author AxGord <axgord@gmail.com>
 */
@:forward(once, listener)
abstract Listener2<T1, T2>(Listener2Impl<T1, T2>) to Listener2Impl<T1, T2> from Listener2Impl<T1, T2> {

	@:from @:extern private static inline function f0<T1, T2>(f: Void -> Void): Listener2<T1, T2>
		return { once: false, listener: LFunction0(f) };
	@:from @:extern private static inline function f1<T1, T2>(f: T1 -> Void): Listener2<T1, T2>
		return { once: false,  listener: LFunction1(f) };
	@:from @:extern private static inline function f2<T1, T2>(f: T1 -> T2 -> Void): Listener2<T1, T2>
		return { once: false,  listener: LFunction2(f) };
	@:from @:extern private static inline function f0c<T1, T2>(f: SignalController2<T1, T2> -> Void): Listener2<T1, T2>
		return { once: false, listener: LFunction0c(f) };
	@:from @:extern private static inline function f0ca<T1, T2>(f: SignalController -> Void): Listener2<T1, T2>
		return { once: false, listener: LFunction0c(cast f) };
	@:from @:extern private static inline function f1c<T1, T2>(f: T1 -> SignalController2<T1, T2> -> Void): Listener2<T1, T2>
		return { once: false,  listener: LFunction1c(f) };
	@:from @:extern private static inline function f1ca<T1, T2>(f: T1 -> SignalController -> Void): Listener2<T1, T2>
		return { once: false,  listener: LFunction1c(cast f) };
	@:from @:extern private static inline function f2c<T1, T2>(f: T1 -> T2 -> SignalController2<T1, T2> -> Void): Listener2<T1, T2>
		return { once: false,  listener: LFunction2c(f) };
	@:from @:extern private static inline function f2ca<T1, T2>(f: T1 -> T2 -> SignalController -> Void): Listener2<T1, T2>
		return { once: false,  listener: LFunction2c(cast f) };
	@:from @:extern private static inline function s0<T1, T2>(f: Event0): Listener2<T1, T2>
		return { once: false,  listener: LEvent0(f) };
	@:from @:extern private static inline function s1<T1, T2>(f: Event1<T1>): Listener2<T1, T2>
		return { once: false, listener: LEvent1(f) };
	@:from @:extern private static inline function s2<T1, T2>(f: Event2<T1, T2>): Listener2<T1, T2>
		return { once: false, listener: LEvent2(f) };

	public inline function call(a1: T1, a2: T2, controller: SignalController2<T1, T2>, ?safe: Bool): Void switch this.listener {
		case LFunction0(f): f();
		case LFunction0c(f): f(controller);
		case LFunction1(f): f(a1);
		case LFunction1c(f): f(a1, controller);
		case LFunction2(f): f(a1, a2);
		case LFunction2c(f): f(a1, a2, controller);
		case LEvent0(s, sv): s.dispatch(sv || safe);
		case LEvent1(s, sv): s.dispatch(a1, sv || safe);
		case LEvent2(s, sv): s.dispatch(a1, a2, sv || safe);
		case LSub(s, v1, v2) if (v1 == a1 && v2 == a2): s.dispatch(safe);
		case LSub1(s, v1) if (v1 == a1): s.dispatch(a2, safe);
		case LSub2(s, v2) if (v2 == a2): s.dispatch(a1, safe);
		case LNot(s, v1, v2) if (v1 != a1 && v2 != a2): s.dispatch(a1, a2, safe);
		case LNot1(s, v1) if (v1 != a1): s.dispatch(a1, a2, safe);
		case LNot2(s, v2) if (v2 != a2): s.dispatch(a1, a2, safe);
		case _:
	}

}