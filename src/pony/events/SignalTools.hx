package pony.events;

import haxe.Constraints.Function;

/**
 * SignalTools
 * @author AxGord <axgord@gmail.com>
 */
class SignalTools {

	#if cs
	@:extern public static inline function functionHashCompare(a: Function, b: Function): Bool return untyped a.GetHashCode() == untyped b.GetHashCode();
	#elseif java
	@:extern public static inline function functionHashCompare(a: Function, b: Function): Bool return untyped a.hashCode() == untyped b.hashCode();
	#elseif (neko || interp)
	@:extern public static inline function functionHashCompare(a: Function, b: Function): Bool return Reflect.compareMethods(a, b);
	#else
	@:extern public static inline function functionHashCompare(a: Function, b: Function): Bool return a == b;
	#end

}