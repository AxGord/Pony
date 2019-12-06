package pony.geom;

import pony.events.Signal1;

/**
 * IWards
 * @author AxGord <axgord@gmail.com>
 */
interface IWards {

	public var currentPos(default, null): Int;
	public var change(get, never): Signal1<Int>;

}