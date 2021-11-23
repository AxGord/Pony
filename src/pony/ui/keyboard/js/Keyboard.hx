package pony.ui.keyboard.js;

import js.html.KeyboardEvent;
import js.Browser;
import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;

/**
 * JS Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard implements HasSignal {

	private static var KEYDOWN: String = 'keydown';
	private static var KEYUP: String = 'keyup';

	@:auto public var down:Signal1<Key>;
	@:auto public var up:Signal1<Key>;

	public function new() {}

	public function enable():Void {
		Browser.window.addEventListener(KEYDOWN, keyDownHandler, true);
		Browser.window.addEventListener(KEYUP, keyUpHandler, true);
	}

	public function disable():Void {
		Browser.window.removeEventListener(KEYDOWN, keyDownHandler, true);
		Browser.window.removeEventListener(KEYUP, keyUpHandler, true);
	}

	private function keyDownHandler(event: KeyboardEvent): Void {
		eDown.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
		event.preventDefault();
	}

	private function keyUpHandler(event: KeyboardEvent): Void {
		eUp.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
		event.preventDefault();
	}

}