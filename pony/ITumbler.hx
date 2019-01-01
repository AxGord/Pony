package pony;

import pony.events.Signal0;

/**
 * ITumbler
 * @author AxGord <axgord@gmail.com>
 */
interface ITumbler {

	var onEnable:Signal0;
	var onDisable:Signal0;
	var enabled(default, set):Bool;
	
	function enable():Void;
	function disable():Void;
	
}