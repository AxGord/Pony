package pony;

/**
 * Object pool interface
 * @author AxGord <axgord@gmail.com>
 */
interface IPool<T> {

	#if !cs
	function get(): T;
	function ret(obj: T): Void;
	function destroy(): Void;
	#end

}