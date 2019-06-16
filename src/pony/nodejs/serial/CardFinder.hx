package pony.nodejs.serial;

import pony.magic.HasSignal;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;

/**
 * CardFinder
 * @author AxGord <axgord@gmail.com>
 */
class CardFinder implements HasSignal {

	@:auto public var onFind:Signal2<Int, String>;
	@:auto public var onNotFind:Signal0;
	@:auto public var onList:Signal1<Array<String>>;
	@:auto public var onBusy:Signal0;

	private var rotors:Rotors;
	private var limit:LimitSwitch;
	private var ppRotor:PingPongRotor;
	private var reader:CardReader;
	private var findTarget:String;
	private var scanList:Array<String>;

	public function new(serial:SerialPort, maxSpeed:Bool = false, maxTime:Int = 10000) {
		rotors = new Rotors(serial, 1);
		limit = new LimitSwitch(serial.onString);
		ppRotor = new PingPongRotor(rotors[0], limit, maxSpeed, maxTime);
		reader = new CardReader(serial.onString);
	}

	public function find(id:String, ignoreBusy:Bool = false):Void {
		if (isBusy(ignoreBusy)) return;
		findTarget = id;
		scanList = [];
		reader.onKey << findHandler;
		ppRotor.onLoop < findFailedHandler;
	}

	private function isBusy(ignoreBusy:Bool = false):Bool {
		if (ignoreBusy) {
			cancel();
			return false;
		} else if (ppRotor.enabled) {
			eBusy.dispatch();
			return true;
		} else {
			return false;
		}
	}

	private function findHandler(key:String):Void {
		keyHandler(key);
		if (key != findTarget) return;
		var count:Int = scanList.length;
		cancelFind();
		eFind.dispatch(count, key);
	}

	private function findFailedHandler():Void {
		cancelFind();
		eNotFind.dispatch();
	}

	public function cancelFind():Void {
		ppRotor.onLoop >> findFailedHandler;
		reader.onKey >> findHandler;
		ppRotor.disable();
		findTarget = null;
		scanList = null;
	}

	public function cancel():Void {
		cancelFind();
		cancelScan();
	}

	public function cancelScan():Void {
		reader.onKey >> keyHandler;
		ppRotor.onLoop >> scanFinishHandler;
		ppRotor.disable();
		scanList = null;
	}

	public function scan(ignoreBusy:Bool = false):Void {
		if (isBusy(ignoreBusy)) return;
		scanList = [];
		reader.onKey << keyHandler;
		ppRotor.onLoop < scanFinishHandler;
	}

	private function keyHandler(key:String):Void {
		scanList.remove(key);
		scanList.push(key);
	}

	private function scanFinishHandler():Void {
		var list:Array<String> = scanList;
		cancelScan();
		eList.dispatch(list);
	}

	public function destroy():Void {
		cancel();
		limit.destroy();
		limit = null;
		ppRotor.destroy();
		ppRotor = null;
		rotors = null;
		reader.destroy();
		reader = null;
		destroySignals();
	}

}