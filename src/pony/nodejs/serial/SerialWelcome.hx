package pony.nodejs.serial;

import pony.text.TextTools;
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
	@:arg private var welcome:Array<String>;
	private var buf:String = '';
	private var maxLength:Int;

	public function new() {
		serial.onString << dataHandler;
		maxLength = TextTools.arrayMaxLength(welcome);
	}

	private function dataHandler(s:String):Void {
		buf += s;
		var needDestroy:Bool = false;
		for (w in welcome) {
			if (buf.length >= w.length) {
				if (buf.indexOf(w) != -1) {
					eWelcome.dispatch(w, serial);
					destroy();
					return;
				} else if (buf.length > maxLength) {
					needDestroy = true;
				}
			}
		}
		if (needDestroy) destroy();
	}

	public function destroy():Void {
		buf = null;
		welcome = null;
		serial.onString >> dataHandler;
		serial = null;
		destroySignals();
	}

}