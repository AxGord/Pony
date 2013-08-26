package pony.flash.ui;

import flash.display.MovieClip;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldType;
import pony.events.Signal;

/**
 * InputBase
 * @author AxGord <axgord@gmail.com>
 */
class InputBase<T> extends MovieClip {

	public var change:Signal;
	public var inp(get,never):TextField;
	public var edit(get, set):Bool;
	public var value(get, set):T;
	
	public function new() {
		super();
		stop();
		change = new Signal();
		inp.addEventListener(Event.CHANGE, chHandler);
	}
	
	private function chHandler(_):Void {
		change.dispatch(value);
	}
	
	inline private function get_inp():TextField return untyped this['input'];
	
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
	
	private function get_value():T return cast inp.text;
	private function set_value(v:T):T return cast inp.text = cast v;
	
}