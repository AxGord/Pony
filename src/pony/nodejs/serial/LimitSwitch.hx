package pony.nodejs.serial;

import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.magic.Declarator;

/**
 * LimitSwitch
 * @author AxGord <axgord@gmail.com>
 */
class LimitSwitch implements Declarator implements HasSignal {

	private static var LIMIT_SWITCH:String = 'LimitSwitch';
	private static var END:String = ';';
	
	private static var LSW1:String = LIMIT_SWITCH + '1_';
	private static var LSW2:String = LIMIT_SWITCH + '2_';

	@:bindable public var state1:Bool = false;
	@:bindable public var state2:Bool = false;
	@:arg private var signal:Signal1<String>;

	public function new() {
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

	public function destroy():Void {
		signal >> dataHandler;
		signal = null;
		destroySignals();
	}

}