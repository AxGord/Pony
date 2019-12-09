package pony.ui.keyboard;

import pony.events.Signal1;

/**
 * IKeyboard
 * @see pony.ui.Keyboard
 * @author AxGord <axgord@gmail.com>
 */
interface IKeyboard {

	var down(get, never): Signal1<Key>;
	var up(get, never): Signal1<Key>;
	function enable(): Void;
	function disable(): Void;

}