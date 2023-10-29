package pony.events;

import haxe.Constraints.Function;

/**
 * SignalTools
 * @author AxGord <axgord@gmail.com>
 */
@SuppressWarnings('checkstyle:MagicNumber')
class SignalTools {

	#if (haxe_ver >= 4.2) extern #else @:extern #end
	#if cs
	public static inline function functionHashCompare(a: Function, b: Function): Bool return untyped a.GetHashCode() == untyped b.GetHashCode();
	#elseif java
	public static inline function functionHashCompare(a: Function, b: Function): Bool return untyped a.hashCode() == untyped b.hashCode();
	#elseif (neko || interp)
	public static inline function functionHashCompare(a: Function, b: Function): Bool return Reflect.compareMethods(a, b);
	#else
	public static inline function functionHashCompare(a: Function, b: Function): Bool return a == b;
	#end

}