package pony;

/**
 * ImmutableArray
 * @author Dima (deep)
 */
@:forward(length)
abstract ImmutableArray<T>(Array<T>) from Array<T> {
	
	@:arrayAccess public inline function arrayAccess(key:Int):T {
		return this[key];
	}
 
	public inline function iterator():Iterator<T> {
		return this.iterator();
	}
 
}