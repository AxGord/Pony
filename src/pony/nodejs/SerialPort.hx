package pony.nodejs;

import js.node.Buffer;
import js.Error;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Log;
import haxe.PosInfos;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.nodejs.SerialPort.SerialPortConfig;
import pony.Queue;
import pony.time.Timer;
import pony.NPM;

using Lambda;

typedef SerialPortConfig = {
	?baudRate:Int,
	?dataBits:Int,
	?stopBits:Int,
	?parity:String,
	?xon:Bool,
	?xoff:Bool,
	?xany:Bool,
	?flowControl:Bool,
	?bufferSize:Int,
	?readString: Bool,
	?notWaitFirstMessage: Bool
};

private typedef SerialPortFullConfig = {
	> SerialPortConfig,
	?disconnectedCallback:Void -> Void
};

typedef SerialId = {
	?comName: String,
	?manufacturer: String,
	?serialNumber: String,
	?pnpId: String,
	?locationId: String,
	?vendorId: String,
	?productId: String
}

/**
 * SerialPort
 * @author AxGord <axgord@gmail.com>
 */
class SerialPort extends Logable implements Declarator {
	
	public var connected(default, null):Bool;
	
	@:auto public var onOpen:Signal0;
	@:auto public var onClose:Signal1<SerialPort>;
	@:auto public var onData:Signal1<BytesInput>;
	@:auto public var onString:Signal1<String>;
	
	private var sp:Dynamic;
	private var q:Queue<BytesOutput -> Void> = new Queue < BytesOutput -> Void > (_write);
	private var lastDelay:Timer;
	
	@:arg public var id:SerialId;
	@:arg private var cfg:SerialPortConfig = {};
	
	public function new() {
		super();
		onError << reconnect;
		onOpen << function() connected = true;
		if (cfg.readString)
			onData.add(dataHandler, 10);
		connect();
	}

	public static function getList(cb:Array<SerialId> -> Void, err:String -> ?PosInfos -> Void):Void {
		try {
			NPM.serialport.list(function(e:Error, ports:Array<SerialId>):Void {
				if (e != null)
					err(e.message);
				else
					cb(ports);
			});
		} catch (e:Error) {
			err(e.message);
		}
	}

	private function dataHandler(bi:BytesInput):Void {
		eString.dispatch(bi.readAll().toString());
	}
	
	private function connect():Void {
		getList(connectHandler, error);
	}

	public function logPorts():Void {
		getList(logPortsHandler, error);
	}

	public static function tracePorts():Void {
		getList(tracePortsHandler, haxe.Log.trace);
	}

	private function logPortsHandler(ports:Array<SerialId>):Void {
		for (port in ports) log(Std.string(port));
	}

	private static function tracePortsHandler(ports:Array<SerialId>):Void {
		for (port in ports) trace(port);
	}
	
	private function connectHandler(ports:Array<SerialId>):Void {
		var e:SerialId = ports.find(findPort);
		if (e == null) return error("Can't find device");
		log('Connect to ' + e.comName);
		try {
			var fcfg:SerialPortFullConfig = cast cfg;
			fcfg.disconnectedCallback = reconnect;
			sp = Type.createInstance(NPM.serialport, [e.comName, fcfg, false]);
			sp.open(function (err:Error) {
				if (err != null && err.message != 'Port is opening') {
					error('Error opening port: ' + err.message);
				} else {
					if (cfg.notWaitFirstMessage) {
						sp.drain(function(err:Dynamic) {
							if (err == null) haxe.Timer.delay(openHandler, 1000);
							else error('Error opening port: ' + err);
						});
					} else {
						sp.once('data', openHandler);
					}
				}
			});
			sp.on('error', error);
			sp.on('close', closeHandler);
			sp.on('data', readData);
		} catch (err:Dynamic) {
			error(Std.string(err));
		}
	}

	private function openHandler():Void {
		eOpen.dispatch();
	}

	private function closeHandler():Void {
		eClose.dispatch(this);
	}

	private function findPort(port:SerialId):Bool {
		return checkPort(id, port);
	}

	/**
	* Check a field in b
	*/
	public static function checkPort(a:SerialId, b:SerialId):Bool {
		if (a.comName != null) if (a.comName != b.comName) return false;
		if (a.manufacturer != null) if (a.manufacturer != b.manufacturer) return false;
		if (a.serialNumber != null) if (a.serialNumber != b.serialNumber) return false;
		if (a.pnpId != null) if (a.pnpId != b.pnpId) return false;
		if (a.locationId != null) if (a.locationId != b.locationId) return false;
		if (a.vendorId != null) if (a.vendorId != b.vendorId) return false;
		if (a.productId != null) if (a.productId != b.productId) return false;
		return true;
	}
	
	private function reconnect():Void {
		connected = false;
		try {
			sp.close(_reconnect);
		} catch (err:Dynamic) {
			_reconnect();
		}
	}
	
	private function _reconnect():Void {
		log('SerialPort ${id.comName} have problem, reconnect after 5sec...');
		lastDelay = Timer.delay('5s', connect);
	}
	
	private function readData(b:BytesData):Void {
		eData.dispatch(new BytesInput(Bytes.ofData(b)));
	}
	
	private function check():Bool {
		if (connected) return false;
		else {
			error('Serial port not ready');
			return true;
		}
	}
	
	public function writeAsync(b:BytesOutput, ok:Void -> Void, ?error:String -> ?PosInfos -> Void):Void {
		if (check()) return;
		sp.write(Buffer.hxFromBytes(b.getBytes()), function(err:Dynamic) {
			if (err == null)
				sp.drain(function(err:Dynamic) {
					if (err == null) haxe.Timer.delay(ok, 12);
					else if (error != null) error(err);
				});
			else if (error != null) error(err);
		});
	}
	
	public function write(b:BytesOutput):Void {
		if (check()) return;
		if (q != null) q.call(b);
	}
	
	private function _write(b:BytesOutput):Void {
		if (q != null) writeAsync(b, q.next, error);
	}

	public function destroy():Void {
		destroySignals();
		q.destroy();
		q = null;
		sp = null;
		id = null;
		cfg == null;
		if (lastDelay != null) {
			lastDelay.destroy();
			lastDelay = null;
		}
	}
	
}