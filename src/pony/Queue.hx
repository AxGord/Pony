package pony;

/**
 * Queue
 * @author AxGord <axgord@gmail.com>
 */
class Queue<T> {

	private var list:List<Array<Dynamic>>;
	public var busy(default, null):Bool = false;
	public var call:T;
	private var method:T;
	
	public function new(method:T) {
		this.method = method;
		list = new List();
		call = Reflect.makeVarArgs(_call);
	}
	
	private function _call(a:Array<Dynamic>):Void {
		if (!busy) {
			busy = true;
			Reflect.callMethod(null, cast method, a);
		} else {
			list.add(a);
		}
	}
	
	inline public function next():Void list.length > 0 ? Reflect.callMethod(null, cast method, list.pop()) : busy = false;
	
	public function destroy():Void {
		list.clear();
		busy = true;
		call = null;
		method = null;
	}

}