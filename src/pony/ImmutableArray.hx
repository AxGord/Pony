package pony;

/**
 * ImmutableArray
 * Thanks for idea: Dima (deep)
 * @author axgord@gmail.com
 */
@:forward(length, concat, join, toString, indexOf, lastIndexOf, copy, iterator, map, filter)
abstract ImmutableArray<T>(Array<T>) from Array<T> to Iterable<T> {
	@:arrayAccess @:extern inline public function arrayAccess(key:Int):T return this[key];
}