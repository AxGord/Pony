package pony.flash.ui;
import flash.display.MovieClip;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.events.Event;
import pony.events.Signal;

/**
 * Input
 * @author AxGord <axgord@gmail.com>
 */
class Input extends MovieClip {

	public var change:Signal;
	public var inp(get,never):TextField;
	public var edit(get, set):Bool;
	public var value(get, set):String;
	
	public function new() {
		super();
		stop();
		change = new Signal();
		inp.addEventListener(Event.CHANGE, chHandler);
	}
	
	private function chHandler(_):Void {
		change.dispatch(value);
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