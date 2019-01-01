package pony;

/**
 * OrState
 * @author AxGord <axgord@gmail.com>
 */
enum OrState<T1,T2> {
	A(v:T1); B(v:T2);
}

/**
 * Or
 * @author AxGord <axgord@gmail.com>
 */
abstract Or<A,B>(OrState<A,B>) from OrState<A,B> to OrState<A,B> {
	
	@:extern inline public function new(p:OrState<A,B>) this = p;
	@:from @:extern inline public static function fromT1<T1,T2>(v:T1):Or<T1,T2> return OrState.A(v);
	@:from @:extern inline public static function fromT2<T1,T2>(v:T2):Or<T1,T2> return OrState.B(v);
	
}