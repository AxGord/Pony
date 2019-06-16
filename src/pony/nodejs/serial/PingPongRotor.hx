package pony.nodejs.serial;

import pony.events.Signal0;
import pony.events.Event0;
import pony.nodejs.serial.Rotors.Rotor;
import pony.time.Timer;

/**
 * PingPongRotor
 * @author AxGord <axgord@gmail.com>
 */
class PingPongRotor extends Tumbler {

	@:auto public var onLoop:Signal0;

	private var rotor:Rotor;
	private var onStop:Signal0;
	private var onStart:Signal0;
	private var startCheckTimer:Timer = new Timer(1000);
	private var firstCheckTimer:Timer;
	private var counter:Int = 3;

	public function new(rotor:Rotor, limit:LimitSwitch, maxSpeed:Bool = false, maxTime:Int = 10000) {
		super(false);
		this.rotor = rotor;
		rotor.max = maxSpeed;
		firstCheckTimer = new Timer(maxTime);
		onStop = limit.changeState1 - true || limit.changeState2 - true;
		onStart = limit.changeState1 - false || limit.changeState2 - false;
		firstCheckTimer.complete < rotor.reverse;
		startCheckTimer.complete << rotor.reverse;
		onStop << rotor.reverse;
		onStop << startCheckTimer.restart.bind(0);
		onStop < firstCheckTimer.stop;
		onStop << stopHandler;
		onStart << startCheckTimer.stop;
		onEnable << rotor.enable;
		onEnable < firstCheckTimer.start.bind(0);
		onDisable << rotor.disable;
		onDisable << resetCounter;
	}

	private function stopHandler():Void {
		if (--counter <= 0) {
			disable();
			eLoop.dispatch();
		}
	}

	private function resetCounter():Void counter = 2;

	public function destroy():Void {
		startCheckTimer.destroy();
		startCheckTimer = null;
		firstCheckTimer.destroy();
		firstCheckTimer = null;
		destroySignals();
		destroySignal(onStart);
		destroySignal(onStop);
		rotor = null;
		onStop = null;
		onStart = null;
	}

	private function destroySignal(s:Signal0):Void {
		var e:Event0 = cast s;
		e.destroy();
	}

}