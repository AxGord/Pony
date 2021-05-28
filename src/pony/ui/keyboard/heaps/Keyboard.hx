package pony.ui.keyboard.heaps;

import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;

/**
 * Heaps Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard implements HasSignal {

	private static var KEYDOWN: String = 'keydown';
	private static var KEYUP: String = 'keyup';

	@:auto public var down:Signal1<Key>;
	@:auto public var up:Signal1<Key>;

	public function new() {}

	public function enable():Void {
		hxd.Window.getInstance().addEventTarget(eventHandler);
	}

	public function disable():Void {
		hxd.Window.getInstance().removeEventTarget(eventHandler);
	}

	private function eventHandler(event : hxd.Event): Void {
		switch event.kind {
			case EKeyDown: eDown.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
			case EKeyUp: eUp.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
			case _:
		}
	}

}