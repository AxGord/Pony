package pony.heaps.ui.gui;

import pony.geom.Point;
import pony.events.Signal2;

/**
 * INode
 * @author AxGord <axgord@gmail.com>
 */
interface INode {

	public var wh(default, set):Point<Float>;
	public var flipx(default, set):Bool;
	public var flipy(default, set):Bool;
	public var changeWh(get, never):Signal2<Point<Float>, Point<Float>>;
	public var changeFlipx(get, never):Signal2<Bool, Bool>;
	public var changeFlipy(get, never):Signal2<Bool, Bool>;
	public var w(get, set):Float;
	public var h(get, set):Float;
	public function set_w(v:Float):Float;
	public function set_h(v:Float):Float;

}