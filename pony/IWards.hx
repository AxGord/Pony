package pony;

import pony.events.Signal;

/**
 * IWards
 * @author AxGord <axgord@gmail.com>
 */
interface IWards {

	public var currentPos(default,null):Int;
	public var change(default,null):Signal;
	
}