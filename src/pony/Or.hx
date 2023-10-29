package pony;

/**
 * OrState
 * @author AxGord <axgord@gmail.com>
 */
enum OrState<T1, T2> {
	A(v: T1);
	B(v: T2);
}

/**
 * Or
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
abstract Or<A, B>(OrState<A, B>) from OrState<A, B> to OrState<A, B> {

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function new(p: OrState<A, B>) this = p;

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromT1<T1, T2>(v: T1): Or<T1, T2> return OrState.A(v);

	@:from
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function fromT2<T1, T2>(v: T2): Or<T1, T2> return OrState.B(v);

}