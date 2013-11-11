package pony.ui;

import pony.events.Signal;
/**
 * IKeyboard
 * @author AxGord <axgord@gmail.com>
 */
interface IKeyboard {

	var down(default, null):Signal;
	var up(default, null):Signal;

	function enable():Void;
	function disable():Void;
	
}