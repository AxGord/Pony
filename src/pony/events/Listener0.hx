package pony.events;

enum Listener0Type {
	LFunction0( f: Void -> Void );
	LFunction0c( f: SignalController0 -> Void );
	LEvent0( s: Event0, ?safe: Bool );
	LBind1( s: Event1<Dynamic>, v: Dynamic );
	LBind2( s: Event2<Dynamic, Dynamic>, v1: Dynamic, v2: Dynamic );
}

typedef Listener0Impl = {
	once: Bool,
	listener: Listener0Type
}

/**
 * Listener0
 * @author AxGord <axgord@gmail.com>
 */
@:forward(once, listener)
abstract Listener0(Listener0Impl) to Listener0Impl from Listener0Impl {
	
	@:from @:extern private static inline function f0<T1>(f: Void -> Void): Listener0 return { once: false, listener: LFunction0(cast f) };
	@:from @:extern private static inline function f0c<T1>(f: SignalController0 -> Void): Listener0
		return { once: false, listener: LFunction0c(f) };
	@:from @:extern private static inline function f0ca<T1>(f: SignalController -> Void): Listener0
		return { once: false, listener: LFunction0c(cast f) };
	@:from @:extern private static inline function s0<T1>(f: Event0): Listener0 return { once: false, listener: LEvent0(f) };

	public inline function call(controller: SignalController0, ?safe: Bool): Void switch this.listener {
		case LFunction0(f): f();
		case LFunction0c(f): f(controller);
		case LEvent0(s, sv): s.dispatch(sv || safe);
		case LBind1(s, v): s.dispatch(v, safe);
		case LBind2(s, v1, v2): s.dispatch(v1, v2, safe);
	}

}