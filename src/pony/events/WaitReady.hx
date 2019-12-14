package pony.events;

/**
 * WaitReady Helper
 * @author AxGord <axgord@gmail.com>
 */
class WaitReady {

	private var isReady: Bool = false;
	private var list: Array<Void -> Void> = [];

	public function new() {}

	public function ready(): Void {
		if (list == null) return;
		isReady = true;
		for (f in list) f();
		list = null;
	}

	public function wait(cb: Void -> Void): Void isReady ? cb() : list.push(cb);

	@:extern public inline function destroy(): Void {
		isReady = false;
		list = null;
	}

}