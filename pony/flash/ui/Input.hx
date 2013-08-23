package pony.flash.ui;
import flash.text.TextField;
import flash.text.TextFieldType;
import pony.flash.ExtendedMovieClip;

/**
 * Input
 * @author AxGord <axgord@gmail.com>
 */
class Input extends ExtendedMovieClip {

	public var inp(get,never):TextField;
	public var edit(get, set):Bool;
	public var value(get, set):String;
	
	public function new() {
		super();
		stop();
	}
	
	inline private function get_inp():TextField return Reflect.field(this,'input');
	
	inline private function get_edit():Bool return inp.type == TextFieldType.INPUT;
	
	private function set_edit(v:Bool):Bool {
		if (v == edit) return v;
		if (v) {
			inp.type = TextFieldType.INPUT;
			inp.selectable = true;
			gotoAndStop(1);
		} else {
			inp.type = TextFieldType.DYNAMIC;
			inp.selectable = false;
			gotoAndStop(2);
		}
		return v;
	}
	
	inline private function get_value():String return inp.text;
	inline private function set_value(v:String):String return inp.text = v;
	
}