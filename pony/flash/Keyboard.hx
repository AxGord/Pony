package pony.flash;

import flash.events.KeyboardEvent;
import flash.Lib;
import pony.events.Signal;
import pony.ui.IKeyboard;

/**
 * Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard {

	public var down(default, null):Signal;
	public var up(default, null):Signal;
	
	public function new() {
		down = new Signal(this);
		up = new Signal(this);	
	}
	
	public function enable():Void {
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, kd);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, ku);
	}
	
	public function disable():Void {
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, kd);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, ku);
	}
	
	private function kd(event:KeyboardEvent):Void down.dispatch(pony.ui.Keyboard.map.get(event.keyCode));
	private function ku(event:KeyboardEvent):Void up.dispatch(pony.ui.Keyboard.map.get(event.keyCode));
	
}