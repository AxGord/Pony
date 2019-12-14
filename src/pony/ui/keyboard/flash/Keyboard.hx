package pony.ui.keyboard.flash;

import flash.display.Stage;
import flash.events.KeyboardEvent;
import pony.flash.MultyStage;
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
		MultyStage.apply(addKeyboardListeners, removeKeyboardListeners);
	}

	public function disable(): Void {
		MultyStage.cancel(addKeyboardListeners, removeKeyboardListeners);
	}

	private function addKeyboardListeners(stage: Stage): Void {
		stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true, 0, true);
		stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler, true, 0, true);
	}

	private function removeKeyboardListeners(stage: Stage): Void {
		stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, true);
		stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler, true);
	}

	private function keyDownHandler(event: KeyboardEvent): Void eDown.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));
	private function keyUpHandler(event: KeyboardEvent): Void eUp.dispatch(pony.ui.keyboard.Keyboard.map.get(event.keyCode));

}