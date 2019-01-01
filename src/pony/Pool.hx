package pony;

/**
 * Object pool
 * @author AxGord <axgord@gmail.com>
 */
class Pool<T> implements IPool<T> {
	
	private var cl:Class<T>;
	private var list:List<T> = new List<T>();

	public function new(cl:Class<T>) {
		this.cl = cl;
	}
	
	public function get():T {
		var v = list.pop();
		return v == null ? Type.createInstance(cl, []) : v;
	}
	
	public function ret(obj:T):Void list.push(obj);
	
}