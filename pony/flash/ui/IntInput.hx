package pony.flash.ui;
import flash.events.Event;
import pony.flash.ExtendedMovieClip;

/**
 * IntInput
 * @author AxGord <axgord@gmail.com>
 */
class IntInput extends Input {

	public var min:Int = 0;
	public var max:Int = 100;
	
	public function new() {
		super();
		addEventListener(ExtendedMovieClip.INIT, init);
	}
	
	private function init(_):Void {
		inp.restrict = '0-9';
		inp.addEventListener(Event.CHANGE, change);
	}
	
	private function change(_):Void {
		var v:Int = Std.parseInt(inp.text);
		if (v < min) inp.text = Std.string(min);
		else if (v > max) inp.text = Std.string(max);
	}
	
}