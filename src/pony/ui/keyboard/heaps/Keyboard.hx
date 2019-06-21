package pony.ui.keyboard.heaps;

import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.ui.keyboard.IKeyboard;
import pony.ui.keyboard.Key;
import hxd.Event;
import hxd.Window;

/**
 * Keyboard
 * @author AxGord <axgord@gmail.com>
 */
class Keyboard implements IKeyboard implements HasSignal {

	@:auto public var down:Signal1<Key>;
	@:auto public var up:Signal1<Key>;
	
	public function new() {}
	
	public function enable():Void {
		Window.getInstance().addEventTarget(eventHandler);
	}
	
	public function disable():Void {
		Window.getInstance().removeEventTarget(eventHandler);
	}
	
	private function eventHandler(event:Event):Void {
		switch event.kind {
			case EKeyDown:
				eDown.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
			case EKeyUp:
				eUp.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
			case _:
		}
	}

}