package pony.heaps.ui.gui;

import h2d.Drawable;
import h2d.Object;
import pony.magic.HasSignal;
import pony.magic.HasLink;
import pony.geom.Point;

/**
 * Node
 * @author AxGord <axgord@gmail.com>
 */
class Node extends Drawable implements HasSignal implements HasLink implements INode {

	@:bindable public var wh:Point<Float>;
	@:bindable public var flipx:Bool;
	@:bindable public var flipy:Bool;
	public var w(link, set):Float = wh.x;
	public var h(link, set):Float = wh.y;

	public function new(size:Point<Float>, ?parent:Object) {
		super(parent);
		wh = size;
	}

	public function set_w(v:Float):Float {
		if (v != wh.x) wh = new Point(v, wh.y);
		return v;
	}

	public function set_h(v:Float):Float {
		if (v != wh.y) wh = new Point(wh.x, v);
		return v;
	}

	public function destroy():Void {
		removeChildren();
		changeWh.clear();
		wh = null;
		remove();
		parent = null;
		destroySignals();
	}

}