package pony.net.rpc;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.HasListener;
import pony.time.Timer;

/**
 * RPCLog
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) final #else @:final #end
class RPCPing extends pony.net.rpc.RPCUnit<RPCPing> implements pony.net.rpc.IRPC {

	private static inline var REPEAR: Int = 5000;

	@:auto public var onWarning: Signal0;
	@:auto public var onRestore: Signal0;
	@:auto public var onLostConnection: Signal0;
	@:auto public var onDelayInfo: Signal1<Float>;

	@:rpc public var onPing: Signal0;
	@:rpc public var onPong: Signal0;

	public function new() {
		super();
		onPing << pongRemote;
	}

	public function watch(repeatTime: Int = REPEAR): Watch return new Watch(this, repeatTime);

}

@:access(pony.net.rpc.RPCPing)
@:nullSafety(Strict)
#if (haxe_ver >= 4.2) final #else @:final #end
class Watch implements HasListener {

	private var rpc: RPCPing;
	private var silent: Bool = false;
	private var ping: Bool = true;
	private var timer: Timer;
	private var startTime: Float = now();

	public function new(rpc: RPCPing, repeatTime: Int) {
		this.rpc = rpc;
		timer = Timer.repeat(repeatTime, repeatHandler);
		timer.frequency = 500;
		repeatHandler();
	}

	public function offline(): Void {
		timer.update >> timerUpdateHandler;
		timer.stop();
		rpc.eLostConnection.dispatch();
	}

	@:listen(rpc.onPong)
	private function pongHandler(): Void {
		timer.update >> timerUpdateHandler;
		if (!rpc.eDelayInfo.empty) rpc.eDelayInfo.dispatch(now() - startTime);
	}

	private function timerUpdateHandler(): Void {
		if (!rpc.eDelayInfo.empty) rpc.eDelayInfo.dispatch(now() - startTime);
	}

	private function repeatHandler(): Void {
		if (silent) {
			timer.update >> timerUpdateHandler;
			if (ping) {
				ping = false;
				rpc.eWarning.dispatch();
				rpc.pingRemote();
			} else {
				offline();
			}
		} else {
			silent = true;
			if (!rpc.eDelayInfo.empty) {
				startTime = now();
				timer.update << timerUpdateHandler;
			}
			rpc.pingRemote();
		}
	}

	@:listen(rpc.onPong)
	public function activity(): Void {
		timer.reset();
		if (silent && !ping) rpc.eRestore.dispatch();
		silent = false;
		ping = true;
	}

	private static inline function now(): Float return haxe.Timer.stamp();

}
