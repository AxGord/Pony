package pony.events;

/**
 * WaitReady Helper
 * @author AxGord <axgord@gmail.com>
 */
abstract WaitReady(Null<Array<Void -> Void>>) {

	@:extern public inline function new() this = [];

	@:extern public inline function ready(): Void {
		if (this != null) {
			@:nullSafety(Off) for (f in this) f();
			this = null;
		}
	}

	@:extern public inline function wait(cb: Void -> Void): Void this == null ? cb() : this.push(cb);

}