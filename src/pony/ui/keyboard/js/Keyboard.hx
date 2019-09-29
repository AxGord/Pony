package pony.ui.keyboard.js;

import js.html.KeyboardEvent;
import js.Browser;
import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;

/**
 * Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard implements HasSignal {

	private static var KEYDOWN: String = 'keydown';
	private static var KEYUP: String = 'keyup';

	@:auto public var down:Signal1<Key>;
	@:auto public var up:Signal1<Key>;
	
	public function new() {}
	
	public function enable():Void {
		Browser.document.addEventListener(KEYDOWN, keyDownHandler);
		Browser.document.addEventListener(KEYUP, keyUpHandler);
	}
	
	public function disable():Void {
		Browser.document.removeEventListener(KEYDOWN, keyDownHandler);
		Browser.document.removeEventListener(KEYUP, keyUpHandler);
	}

	private function keyDownHandler(event: KeyboardEvent): Void {
		eDown.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
	}

	private function keyUpHandler(event: KeyboardEvent): Void {
		eUp.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
	}

}