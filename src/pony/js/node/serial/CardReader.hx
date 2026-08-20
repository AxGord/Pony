package pony.js.node.serial;

import pony.events.Signal1;
import pony.magic.HasSignal;
import haxe.io.BytesInput;

/**
 * CardReader
 * RFID-RC522
 * @author AxGord <axgord@gmail.com>
 */
class CardReader implements HasSignal {

	private static final KEYWORD: String = 'Card UID: ';
	private static final KEYLENGTH: Int = KEYWORD.length;

	@:auto public var onKey: Signal1<String>;

	private final signal: Signal1<String>;
	private var buf: String = '';
	private var keyopened: Bool = false;

	public function new(signal: Signal1<String>) {
		this.signal = signal;
		signal << dataHandler;
	}

	private function dataHandler(s: String): Void {
		buf += s;
		if (!keyopened) {
			final index: Int = buf.indexOf(KEYWORD);
			if (index != -1) {
				keyopened = true;
				buf = buf.substr(index + KEYLENGTH);
			}
		}
		if (keyopened) {
			final endIndex: Int = buf.indexOf('\n');
			if (endIndex != -1) {
				keyopened = false;
				var s = buf.substr(0, endIndex);
				s = StringTools.replace(s, ' ', '');
				eKey.dispatch(s);
				buf = buf.substr(endIndex + 1);
			}
		}
	}

	public function destroy(): Void {
		signal >> dataHandler;
		destroySignals();
	}

}
