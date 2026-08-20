package pony.js.node.serial;

import haxe.io.BytesInput;
import pony.events.Signal2;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.text.TextTools;
import pony.time.Time;
import pony.time.Timer;

/**
 * SerialWelcome
 * @author AxGord <axgord@gmail.com>
 */
class SerialWelcome implements Declarator implements HasSignal {

	@:auto public var onWelcome: Signal2<String, SerialPort>;

	@:arg private var serial: SerialPort;
	@:arg private var welcome: Array<String>;
	private var buf: String = '';
	private var maxLength: Int;
	private var delay: Timer;
	private var welcomeMessage: String;

	public function new(?delay: Time) {
		if (delay != null) {
			this.delay = new Timer(delay);
			this.delay.complete << connect;
		}
		serial.onString << dataHandler;
		maxLength = TextTools.arrayMaxLength(welcome);
	}

	private function connect(): Void {
		eWelcome.dispatch(welcomeMessage, serial);
		destroy();
	}

	private function dataHandler(s: String): Void {
		buf += s;
		var needDestroy: Bool = false;
		for (w in welcome) {
			if (buf.length >= w.length) {
				if (buf.indexOf(w) != -1) {
					welcomeMessage = w;
					if (delay != null)
						delay.start();
					else
						connect();
					return;
				} else if (buf.length > maxLength) {
					needDestroy = true;
				}
			}
		}
		if (needDestroy) destroy();
	}

	public function destroy(): Void {
		buf = null;
		welcome = null;
		serial.onString >> dataHandler;
		serial = null;
		destroySignals();
	}

}
