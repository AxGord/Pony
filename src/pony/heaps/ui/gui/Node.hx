package pony.heaps.ui.gui;

import h2d.Bitmap;
import h2d.Tile;
import h2d.Interactive;
import h2d.Object;

#if (heaps >= '2.0.0')
import h3d.Vector4 as Vector;
#else
import h3d.Vector;
#end

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

	public function makeInteractive(?cursor: Cursor): Void {
		interactive = new Interactive(w, h, this);
		interactive.cursor = cursor;
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

	public function setContentRotation(degrees: Float, px: Null<Float>, py: Null<Float>): Void {
		for (child in children) {
			#if (haxe_ver >= 4.10)
			if (Std.isOfType(child, Bitmap)) {
			#else
			if (Std.is(child, Bitmap)) {
			#end
				if (px != null || py != null)
					cast(child, Bitmap).tile.setCenterRatio(px != null ? px : 0, py != null ? py : 0);
				child.rotation = degrees * Math.PI / 180;
			}
		}
	}

	public function setTile(tile: Tile): Void {
		for (child in children) {
			#if (haxe_ver >= 4.10)
			if (Std.isOfType(child, Bitmap)) {
			#else
			if (Std.is(child, Bitmap)) {
			#end
				cast(child, Bitmap).tile = tile;
				break;
			}
		}
	}

	public function destroyIWH(): Void destroy();
	public inline function show(): Void visible = true;
	public inline function hide(): Void visible = false;

}