package pony.flash;

import flash.events.KeyboardEvent;
import flash.Lib;
import pony.events.Signal;
import pony.events.Signal1;
import pony.ui.IKeyboard;
import pony.ui.Key;

/**
 * Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard<Keyboard> {

	public var down(default, null):Signal1<Keyboard, Key>;
	public var up(default, null):Signal1<Keyboard, Key>;
	
	public function new() {
		down = Signal.create(this);
		up = Signal.create(this);	
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