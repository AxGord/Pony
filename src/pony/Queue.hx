package pony;

/**
 * Queue
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Queue<T> {

	public var busy(default, null): Bool;
	public var call(default, null): T;
	public var hasNext(get, never): Bool;

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

	private inline function get_hasNext(): Bool return list.length > 0;

	public inline function next(): Void hasNext ? @:nullSafety(Off) cm(list.pop()) : busy = false;

	private inline function cm(args: Array<Dynamic>): Void @:nullSafety(Off) Reflect.callMethod(null, cast method, args);

	public inline function destroy(): Void {
		list.clear();
		busy = true;
		@:nullSafety(Off) call = null;
		@:nullSafety(Off) method = null;
	}

}

/**
 * Queue0
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Queue0 {

	public var hasNext(get, never): Bool;

	private var count: UInt = 0;
	private var method: Void -> Void;

	public function new(method: Void -> Void, busy: Bool = false) {
		this.method = method;
		count = busy ? 1 : 0;
	}

	public function call(): Void {
		if (count == 0) method();
		count++;
	}

	private inline function get_hasNext(): Bool return count > 1;

	public inline function next(): Void {
		if (hasNext) method();
		count--;
	}

	public inline function destroy(): Void {
		count = 0;
		@:nullSafety(Off) method = null;
	}

}

/**
 * Queue1
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class Queue1<T1> {

	public var busy(default, null): Bool;
	public var hasNext(get, never): Bool;

	private var list: List<T1>;
	private var method: T1 -> Void;

	public function new(method: T1 -> Void, busy: Bool = false) {
		this.method = method;
		this.busy = busy;
		list = new List();
	}

	public function call(a1: T1): Void {
		if (!busy) {
			busy = true;
			method(a1);
		} else {
			list.add(a1);
		}
	}

	private inline function get_hasNext(): Bool return list.length > 0;

	public inline function next(): Void hasNext ? @:nullSafety(Off) method(list.pop()) : busy = false;

	public inline function destroy(): Void {
		list.clear();
		busy = true;
		@:nullSafety(Off) method = null;
	}

}
