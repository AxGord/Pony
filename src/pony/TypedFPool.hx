package pony;

/**
 * Typed object pool, using create function
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class TypedFPool<T> implements IPool<T> {

	private var list:Array<T> = [];
	private var fn: Void -> T;

	public function new(fn: Void -> T) this.fn = fn;

	public inline function get(): T {
		var v: Null<T> = list.pop();
		return v == null ? fn() : v;
	}

	public inline function ret(obj: T): Void list.push(obj);

	@:nullSafety(Off) public inline function destroy(): Void {
		list = null;
		fn = null;
	}

}