package pony.events;

/**
 * Waiter
 * @author AxGord <axgord@gmail.com>
 */
class Waiter {

	public var ready: Bool = false;
	private var f: List<Void -> Void>;

	@:deprecated('Please use WairReady')
	public function new() {
		f = new List<Void -> Void>();
	}

	public function wait(cb: Void -> Void): Void {
		if (ready) cb();
		else f.push(cb);
	}

	public function end(): Void {
		if (ready) throw 'Double ready';
		ready = true;
		for (e in f) e();
		f = null;
	}

}