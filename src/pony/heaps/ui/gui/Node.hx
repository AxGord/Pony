package pony.heaps.ui.gui;

import h3d.Vector;
import h2d.Object;
import pony.magic.HasSignal;
import pony.magic.HasLink;
import pony.geom.Point;
import pony.geom.IWH;

/**
 * Node
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class Node extends Object implements HasSignal implements HasLink implements INode implements IWH {

	@:nullSafety(Off) @:bindable public var wh: Point<Float>;
	@:bindable public var flipx: Bool = false;
	@:bindable public var flipy: Bool = false;
	public var w(link, set): Float = wh.x;
	public var h(link, set): Float = wh.y;
	public var size(link, never): Point<Float> = wh;
	@:bindable public var tint: Vector = new Vector(1, 1, 1, 1);

	public function new(size: Point<Float>, ?parent: Object) {
		super(parent);
		wh = size;
	}

	public inline function set_w(v: Float): Float {
		if (v != wh.x) wh = new Point(v, wh.y);
		return v;
	}

	public inline function set_h(v: Float): Float {
		if (v != wh.y) wh = new Point(wh.x, v);
		return v;
	}

	public function wait(cb: Void -> Void): Void cb();

	public function destroy():Void {
		removeChildren();
		changeWh.clear();
		@:nullSafety(Off) wh = null;
		remove();
		@:nullSafety(Off) parent = null;
		destroySignals();
	}

	public function destroyIWH(): Void destroy();

}