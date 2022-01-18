package pony.heaps.ui.gui;

import h2d.Interactive;
import h2d.Object;

import h3d.Vector;

import hxd.Cursor;

import pony.geom.Border;
import pony.geom.IWH;
import pony.geom.Point;
import pony.magic.HasLink;
import pony.magic.HasSignal;

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
	public var size(get, never): Point<Float>;
	@:bindable public var tint: Vector = new Vector(1, 1, 1, 1);
	public var interactive(default, null): Null<Interactive>;
	private var border: Border<Int>;

	public function new(size: Point<Float>, ?border: Border<Int>, ?parent: Object) {
		super(parent);
		wh = size;
		this.border = border == null ? 0 : border;
	}

	public function makeInteractive(): Void {
		interactive = new Interactive(w, h, this);
		interactive.cursor = null;
		changeWh << setInteractiveSize;
	}

	public function unmakeInteractive(): Void {
		changeWh >> setInteractiveSize;
		interactive.remove();
		interactive = null;
	}

	@:nullSafety(Off) private function setInteractiveSize(wh: Point<Float>): Void {
		interactive.width = wh.x;
		interactive.height = wh.y;
	}

	private inline function get_size(): Point<Float> {
		return new Point(w + border.left + border.right, h + border.top + border.bottom);
	}

	public inline function set_w(v: Float): Float {
		if (v != w) wh = new Point(v, h);
		return v;
	}

	public inline function set_h(v: Float): Float {
		if (v != h) wh = new Point(w, v);
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
	public inline function show(): Void visible = true;
	public inline function hide(): Void visible = false;

}