package pony.events;

import haxe.Constraints.Function;

/**
 * SignalTools
 * @author AxGord <axgord@gmail.com>
 */
class SignalTools {

	#if cs
	@:extern inline public static function functionHashCompare(a:Function, b:Function):Bool return untyped a.GetHashCode() == untyped b.GetHashCode();
	#elseif java
	@:extern inline public static function functionHashCompare(a:Function, b:Function):Bool return untyped a.hashCode() == untyped b.hashCode();
	#elseif neko
	@:extern inline public static function functionHashCompare(a:Function, b:Function):Bool return Reflect.compareMethods(a, b);
	#else
	@:extern inline public static function functionHashCompare(a:Function, b:Function):Bool return a == b;
	#end
	
}