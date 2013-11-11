package pony.ui;
import pony.events.Signal;

/**
 * IFocus
 * @author AxGord <axgord@gmail.com>
 */
interface IFocus {

	public var focus(default, null):Signal;
	public var focusPriority(default, null):Int;
	public var focusGroup(default, null):String;
	
}