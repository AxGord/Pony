package pony.flash.ui;
import flash.events.Event;
using pony.Tools;
/**
 * FloatInput
 * @author AxGord <axgord@gmail.com>
 */
class FloatInput extends InputBase<Null<Float>> {

	public var cafterdot:Int = 1;
	public var min:Float = 0;
	public var max:Float = 100;
	
	public function new() {
		super();
		inp.removeEventListener(Event.CHANGE, chHandler);
		inp.addEventListener(Event.CHANGE, changeHandler);
		inp.restrict = '0-9.';
	}
	
	private function changeHandler(_):Void {
		var v:Float = value;
		if (v < min) value = min;
		else if (v > max) value = max;
		change.dispatch(value);
	}
	
	override private function get_value():Null<Float> {
		if (inp.text == '') return null;
		return Std.parseFloat(inp.text);
	}
	
	override private function set_value(v:Null<Float>):Null<Float> {
		inp.text = v == null ? '' : v._toFixed(cafterdot);
		return v;
	}
	
}