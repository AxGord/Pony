package pony.ui.keyboard.flash;

import flash.events.KeyboardEvent;
import flash.Lib;
import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;
import pony.ui.keyboard.Keyboard;

/**
 * Flash Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard implements HasSignal {

	@:auto public var down: Signal1<Key>;
	@:auto public var up: Signal1<Key>;

	public function new() {}

	public function enable(): Void {
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, kd);
		Lib.current.stage.addEventListener(KeyboardEvent.KEY_UP, ku);
	}

	public function disable(): Void {
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_DOWN, kd);
		Lib.current.stage.removeEventListener(KeyboardEvent.KEY_UP, ku);
	}

	private function kd(event: KeyboardEvent): Void eDown.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
	private function ku(event: KeyboardEvent): Void eUp.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));

}