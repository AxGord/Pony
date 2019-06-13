
package pony.nodejs;

import pony.events.Signal1;
import pony.magic.HasSignal;

class LimitSwitch implements HasSignal {

	private static var LIMIT_SWITCH:String = 'LimitSwitch';
	private static var END:String = ';';
	
	private static var LSW1:String = LIMIT_SWITCH + '1_';
	private static var LSW2:String = LIMIT_SWITCH + '2_';

	@:bindable public var state1:Bool = false;
	@:bindable public var state2:Bool = false;

	public function new(signal:Signal1<String>) {
		// this.signal = signal;
		signal << dataHandler;
	}

	private function dataHandler(s:String):Void {
		var v:Int = extract(s, LSW1);
		if (v != null) state1 = v == 1;
		v = extract(s, LSW2);
		if (v != null) state2 = v == 1;
	}

	private function extract(buf:String, key:String):Int {
		var index:Int = buf.indexOf(key);
		if (index != -1) {
			var v:String = buf.substr(index + key.length);
			index = v.indexOf(END);
			v = v.substr(0, index);
			return Std.parseInt(v);
		} else {
			return null;
		}
	}

}