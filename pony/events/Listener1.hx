package pony.events;

enum Listener1Type<T1> {
	LFunction0( f:Void->Bool );
	LFunction1( f:T1->Bool );
	LEvent0( s:Event0, ?safe:Bool );
	LEvent1( s:Event1<T1>, ?safe:Bool );
	LSub( s:Event0, v:T1 );
	LNot( s:Event1<T1>, v:T1 );
	LBind1( s:Event2<T1, Dynamic>, v1:Dynamic );
}

typedef Listener1_ < T1 > = { once:Bool, listener:Listener1Type<T1> }

/**
 * Listener1
 * @author AxGord <axgord@gmail.com>
 */
@:forward(once, listener)
abstract Listener1<T1>(Listener1_<T1>) to Listener1_<T1> from Listener1_<T1> {
	
	@:from @:extern inline private static function f0<T1>(f:Void->Void):Listener1<T1> return { once:false, listener:LFunction0(cast f) };
	@:from @:extern inline private static function f1<T1>(f:T1->Void):Listener1<T1> return { once:false,  listener:LFunction1(cast f) };
	@:from @:extern inline private static function s0<T1>(f:Event0):Listener1<T1> return { once:false,  listener:LEvent0(f) };
	@:from @:extern inline private static function s1<T1>(f:Event1<T1>):Listener1<T1> return { once:false, listener:LEvent1(f) };
	inline public function call(a1:T1, ?safe:Bool):Bool return switch this.listener {
		case LFunction0(f): f();
		case LFunction1(f): f(a1);
		case LEvent0(s, sv): s.dispatch(sv||safe);
		case LEvent1(s, sv): s.dispatch(a1, sv||safe);
		case LSub(s, v) if (v == a1): s.dispatch(safe);
		case LNot(s, v) if (v != a1): s.dispatch(a1, safe);
		case LBind1(s, v1): s.dispatch(a1, v1, safe);
		case _: false;
	}
}