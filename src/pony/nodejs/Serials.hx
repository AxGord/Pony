package pony.nodejs;

import pony.Pair;
import pony.Logable;
import pony.events.Signal2;
import pony.nodejs.SerialPort;

class Serials extends Logable {

	@:auto public var onConnect:Signal2<String, SerialPort>;

	private var list:Map<String, SerialId>;
	private var cfg:SerialPortConfig;

	public function new(list:Map<String, SerialId>, ?cfg:SerialPortConfig) {
		super();
		this.list = list;
		if (cfg == null) cfg = {};
		cfg.readString = true;
		this.cfg = cfg;
		SerialPort.getList(listHandler, error);
	}

	private function listHandler(plist:Array<SerialId>):Void {
		var created:Array<String> = [];
		for (key in list.keys()) {
			var o:SerialId = list[key];
			for (e in plist) {
				if (SerialPort.checkPort(o, e)) {
					if (created.indexOf(e.comName) == -1) {
						created.push(e.comName);
						new SerialWelcome(new SerialPort(e, cfg), key).onWelcome < eConnect;
					}
				}
			}
		}
	}

}