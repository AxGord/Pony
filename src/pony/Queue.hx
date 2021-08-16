package pony;

/**
 * Queue
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Queue<T> {

	public var busy(default, null): Bool;
	public var call(default, null): T;

	private var list: List<Array<Dynamic>>;
	private var method: T;

	public function new(method: T, busy: Bool = false) {
		this.method = method;
		this.busy = busy;
		list = new List();
		call = Reflect.makeVarArgs(_call);
	}

	private function _call(a: Array<Dynamic>): Void {
		if (!busy) {
			busy = true;
			cm(a);
		} else {
			list.add(a);
		}
	}

	public inline function next(): Void list.length > 0 ? @:nullSafety(Off) cm(list.pop()) : busy = false;

	private inline function cm(args: Array<Dynamic>): Void @:nullSafety(Off) Reflect.callMethod(null, cast method, args);

	public inline function destroy(): Void {
		list.clear();
		busy = true;
		@:nullSafety(Off) call = null;
		@:nullSafety(Off) method = null;
	}

}