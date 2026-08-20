package pony;

/**
 * Object pool
 * @author AxGord <axgord@gmail.com>
 */
class Pool<T> implements IPool<T> {

	private var list: List<T> = new List<T>();
	private var cl: Class<T>;

	public function new(cl: Class<T>) this.cl = cl;

	public inline function get(): T {
		final v: Null<T> = list.pop();
		return v != null ? v : Type.createInstance(cl, []);
	}

	public inline function ret(obj: T): Void list.push(obj);

	public function destroy(): Void {
		cl = null;
		list = null;
	}

}
