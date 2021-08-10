package pony.events;

/**
 * WaitReady Helper
 * @author AxGord <axgord@gmail.com>
 */
abstract WaitReady(Null<Array<Void -> Void>>) {

	public var isReady(get, never): Bool;

	@:extern public inline function new() this = [];

	@:extern public inline function ready(): Void {
		if (this != null) {
			var l: Array<Void -> Void> = this;
			this = null;
			for (f in l) f();
		}
	}

	@:extern public inline function get_isReady(): Bool return this == null;

	@:extern public inline function wait(cb: Void -> Void): Void isReady ? cb() : this.push(cb);

}