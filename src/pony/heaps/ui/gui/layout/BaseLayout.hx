package pony.heaps.ui.gui.layout;

import h2d.RenderContext;
import h2d.Object;
import h2d.Mask;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ui.gui.BaseLayoutCore;
import pony.magic.HasLink;
import pony.magic.HasSignal;

/**
 * BaseLayout
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class BaseLayout<T: BaseLayoutCore<Object>> extends Object implements IWH implements HasLink implements HasSignal {

	@:bindable public var wh: Point<Float> = new Point(0., 0.);
	@:bindable public var flipx: Bool = false;
	@:bindable public var flipy: Bool = false;
	public var w(link, set): Float = wh.x;
	public var h(link, set): Float = wh.y;
	public var layout(default, null): T;
	public var size(get, never): Point<Float>;
	public var mask: Bool;

	public function new(layout: T, mask: Bool = false) {
		super();
		this.layout = layout;
		this.mask = mask;
		layout.getSize = _getSize;
		layout.getSizeMod = getSizeMod;
		layout.setXpos = setXpos;
		layout.setYpos = setYpos;
	}

	override private function drawRec(ctx: RenderContext): Void {
		if (mask) Mask.maskWith(ctx, this, Std.int(w), Std.int(h), 0, 0);
		super.drawRec(ctx);
		if (mask) Mask.unmask(ctx);
	}

	public inline function add(obj: Object): Void {
		addChild(obj);
		if (canAdd(obj)) layout.add(obj);
	}

	public inline function addAt(obj: Object, index: Int): Void {
		addChildAt(obj, index);
		if (canAdd(obj)) layout.addAt(obj, index);
	}

	public inline function addToBegin(obj: Object): Void {
		addChildAt(obj, 0);
		if (canAdd(obj)) layout.addToBegin(obj);
	}

	public inline function rm(obj: Object): Void {
		removeChild(obj);
		layout.remove(obj);
	}

	public inline function clear(): Void {
		removeChildren();
		layout.removeAll();
	}

	private function setXpos(obj: Object, v: Float): Void obj.x = v;
	private function setYpos(obj: Object, v: Float): Void obj.y = v;

	public function wait(cb: Void -> Void): Void layout.wait(cb);

	private function _getSize(o: Object): Point<Float> {
		var b = o.getBounds();
		return new Point(b.width, b.height);
	}

	private static function getSizeMod(o: Object, p: Point<Float>): Point<Float> {
		return new Point(p.x * o.scaleX, p.y * o.scaleY);
	}

	private inline function get_size(): Point<Float> {
		return visible ? layout.size : new Point<Float>(0, 0);
	}

	public function destroyIWH(): Void {
		layout.destroy();
		@:nullSafety(Off) layout = null;
	}

	public function set_w(v: Float): Float {
		if (v != wh.x) wh = new Point(v, wh.y);
		return v;
	}

	public function set_h(v: Float): Float {
		if (v != wh.y) wh = new Point(wh.x, v);
		return v;
	}

	public inline function show(): Void visible = true;
	public inline function hide(): Void visible = false;

	private static inline function canAdd(obj: Object): Bool {
		#if (haxe_ver >= 4.10)
		return !Std.isOfType(obj, Repeat);
		#else
		return !Std.is(obj, Repeat);
		#end
	}

}