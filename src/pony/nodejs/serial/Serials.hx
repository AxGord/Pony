package pony.nodejs.serial;

import pony.Pair;
import pony.Logable;
import pony.time.Timer;
import pony.events.Signal2;
import pony.nodejs.serial.SerialPort;

class Serials extends Logable {

	@:auto public var onConnect:Signal2<String, SerialPort>;

	private var list:Map<String, SerialId>;
	private var cfg:SerialPortConfig;
	private var founded:Array<String> = [];
	private var created:Array<String> = [];
	private var timer:Timer = new Timer('3s', -1);

	public function new(list:Map<String, SerialId>, ?cfg:SerialPortConfig) {
		super();
		this.list = list;
		if (cfg == null) cfg = {};
		cfg.readString = true;
		this.cfg = cfg;
		updateList();
		timer.complete << updateList;
	}

	private function updateList():Void {
		SerialPort.getList(listHandler, error);
	}

	private function listHandler(plist:Array<SerialId>):Void {
		var keys:Array<String> = [for (k in list.keys()) if (founded.indexOf(k) == -1) k];
		for (key in keys) {
			var o:SerialId = list[key];
			for (e in plist) {
				if (created.indexOf(e.comName) == -1 && SerialPort.checkPort(o, e)) {
					created.push(e.comName);
					new SerialWelcome(new SerialPort(e, cfg), keys).onWelcome < connectHandler;
				}
			}
		}
		updateTimerState();
	}

	private function updateTimerState():Void {
		if (founded.length < Lambda.count(list)) {
			timer.reset();
			timer.start();
		} else {
			timer.stop();
		}
	}

	private function connectHandler(module:String, port:SerialPort):Void {
		founded.push(module);
		eConnect.dispatch(module, port);
		port.onClose.once(function() founded.remove(module), 100);
		port.onClose.once(closeHandler, 100);
		updateTimerState();
	}

	private function closeHandler(port:SerialPort):Void {
		created.remove(port.id.comName);
		port.destroy();
		updateTimerState();
	}

	public function destroy():Void {
		// todo destroy created serial ports?
		destroySignals();
		timer.destroy();
		timer = null;
		list = new Map();
		founded = [];
		created = [];
		cfg = null;
	}

}