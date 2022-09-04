package pony.ui.keyboard;

import pony.events.Signal1;

/**
 * IKeyboard
 * @see pony.ui.Keyboard
 * @author AxGord <axgord@gmail.com>
 */
interface IKeyboard {

	var preventDefault: Bool;
	var down(get, never): Signal1<Key>;
	var up(get, never): Signal1<Key>;
	var input(get, never): Signal1<UInt>;
	function enable(): Void;
	function disable(): Void;

}