
package pony.nodejs;

import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.magic.Declarator;
import haxe.io.BytesInput;

/**
 * SerialWelcome
 * @author AxGord <axgord@gmail.com>
 */
class SerialWelcome implements Declarator implements HasSignal {

	@:auto public var onWelcome:Signal2<String, SerialPort>;

	@:arg private var serial:SerialPort;
	@:arg private var welcome:String;
	private var buf:String;

	public function new() {
		serial.onString << dataHandler;
	}

	private function dataHandler(s:String):Void {
		buf += s;
		if (buf.length >= welcome.length) {
			if (buf.indexOf(welcome) != -1) {
				eWelcome.dispatch(welcome, serial);
				destroy();
			} else if (buf.length > welcome.length) {
				destroy();
			}
		}
	}

	public function destroy():Void {
		buf = null;
		serial.onString >> dataHandler;
		destroySignals();
	}

}