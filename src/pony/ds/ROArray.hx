package pony.ds;

import pony.Tools.ArrayTools;

/**
 * Read Only Array (Immutable Array)
 * Thanks for idea: Dima (deep)
 * @author AxGord <axgord@gmail.com>
 */
@:forward(length, concat, join, toString, indexOf, lastIndexOf, copy, iterator, map, filter)
abstract ROArray<T>(Array<T>) from Array<T> to Iterable<T> {

	@:arrayAccess @:extern public inline function arrayAccess(key: Int): T return this[key];

	#if (haxe_ver >= '4.0.0')
	public inline function keyValueIterator(): KeyValueIterator<UInt, T> {
		return new ROArrayIterator(this);
	}
	#end

	@:extern public inline function kv<T>(): Iterator<KeyValue<Int, T>> return ArrayTools.kv(cast this);

}

#if (haxe_ver >= '4.0.0')
final class ROArrayIterator<T> {

	public var hasNext: Void -> Bool;
	private final a: ROArray<T>;
	private final it: Iterator<UInt>;

	public inline function new(a: ROArray<T>) {
		this.a = a;
		it = 0...a.length;
		hasNext = it.hasNext;
	}

	public inline function next(): {key: UInt, value: T} {
		final n: UInt = it.next();
		return { key: n, value: a[n] };
	}

}
#end