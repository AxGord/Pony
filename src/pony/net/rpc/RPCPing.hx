package pony.net.rpc;

import pony.events.Signal0;
import pony.time.Timer;

/**
 * RPCLog
 * @author AxGord <axgord@gmail.com>
 */
@:final class RPCPing extends pony.net.rpc.RPCUnit<RPCPing> implements pony.net.rpc.IRPC {

	private static inline var REPEAR:Int = 10000;

	@:auto public var onWarning:Signal0;
	@:auto public var onRestore:Signal0;
	@:auto public var onLostConnection:Signal0;

	@:rpc public var onPing:Signal0;
	@:rpc public var onPong:Signal0;

	public function new() {
		super();
		onPing << pongRemote;
	}

	public function watch(repeatTime:Int = REPEAR):Void -> Void return new Watch(this, repeatTime).activity;

}

private class Watch {

	private var rpc:RPCPing;
	private var silent:Bool = false;
	private var ping:Bool = true;
	private var timer:Timer;

	public function new(rpc:RPCPing, repeatTime:Int) {
		this.rpc = rpc;
		rpc.onPing << activity;
		rpc.onPong << activity;
		timer = Timer.repeat(repeatTime, repeatHandler);
	}

	private function repeatHandler():Void {
		if (silent) {
			if (ping) {
				ping = false;
				@:privateAccess rpc.eWarning.dispatch();
				rpc.pingRemote();
			} else {
				@:privateAccess rpc.eLostConnection.dispatch();
			}
		} else {
			silent = true;
		}
	}

	public function activity():Void {
		timer.reset();
		if (silent && !ping) @:privateAccess rpc.eRestore.dispatch();
		silent = false;
		ping = true;
	}

}