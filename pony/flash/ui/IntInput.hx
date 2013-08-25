package pony.flash.ui;
import flash.events.Event;
import pony.events.Signal;

/**
 * IntInput
 * @author AxGord <axgord@gmail.com>
 */
class IntInput extends Input {

	public var min:Int = 0;
	public var max:Int = 100;
	
	public function new() {
		super();
		inp.removeEventListener(Event.CHANGE, chHandler);
		inp.addEventListener(Event.CHANGE, changeHandler);
		inp.restrict = '0-9';
	}
	
	private function changeHandler(_):Void {
		var v:Int = Std.parseInt(value);
		if (v < min) value = Std.string(min);
		else if (v > max) value = Std.string(max);
		change.dispatch(v);
	}
	
}