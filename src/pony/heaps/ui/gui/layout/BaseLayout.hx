package pony.heaps.ui.gui.layout;

import h2d.Object;
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

	public function new(layout: T) {
		super();
		this.layout = layout;
		layout.getSize = _getSize;
		layout.getSizeMod = getSizeMod;
		layout.setXpos = setXpos;
		layout.setYpos = setYpos;
	}

	public function add(obj: Object): Void {
		addChild(obj);
		layout.add(obj);
	}

	public function addAt(obj: Object, index: Int): Void {
		addChildAt(obj, index);
		layout.addAt(obj, index);
	}

	public function addToBegin(obj: Object): Void {
		addChildAt(obj, 0);
		layout.addToBegin(obj);
	}

	public function rm(obj: Object): Void {
		removeChild(obj);
		layout.remove(obj);
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

}