package pony.ui.gui;

import pony.geom.Align;
import pony.geom.Border;
import pony.geom.GeomTools;

using pony.Tools;

/**
 * AlignLayoutCore
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class AlignLayoutCore<T> extends BaseLayoutCore<T> {

	@:arg private var _align: Align = new Pair(VAlign.Middle, HAlign.Center);
	@:arg private var _border: Border<Int> = 0;

	public var align(get, set): Align;
	public var border(get, set): Border<Int>;

	override public function update(): Void {
		if (objects == null) return;
		if (!ready) return;
		if (objects.length == 0) {
			_w = 0;
			_h = 0;
			return;
		}
		if (objects.length == 1) {
			_w = getObjSize(objects[0]).x;
			_h = getObjSize(objects[0]).y;
		} else {
			if (align.horizontal != null) {
				_w = 0;
				var sizesX = [for (obj in objects) {
					var os = getObjSize(obj);
					if (os != null) {
						var s = os.x;
						if (s > _w) _w = s;
						s;
					} else {
						0;
					}
				}];
				for (p in GeomTools.halign(align, _w, sizesX).pair(objects)) setXpos(p.b, Std.int(p.a) + _border.left);
			} else {
				_w = 0;
				for (obj in objects) {
					var os = getObjSize(obj);
					if (os != null) {
						var s = os.x;
						if (s > _w) _w = s;
					}
				}
			}
			if (align.vertical != null) {
				_h = 0;
				var sizesY = [for (obj in objects) {
					var os = getObjSize(obj);
					if (os != null) {
						var s = os.y;
						if (s > _h) _h = s;
						s;
					} else {
						0;
					}
				}];
				for (p in GeomTools.valign(align, _h, sizesY).pair(objects)) setYpos(p.b, Std.int(p.a) + _border.top);
			} else {
				_h = 0;
				for (obj in objects) {
					var os = getObjSize(obj);
					if (os != null) {
						var s = os.y;
						if (s > _h) _h = s;
					} else {
						0;
					}
				}
			}
		}
		super.update();
	}

	@:extern private inline function get_align(): Align return _align;

	@:extern private inline function set_align(v: Align): Align {
		if (align == v) return v;
		_align = v;
		update();
		return v;
	}

	@:extern private inline function get_border(): Border<Int> return _border;

	@:extern private inline function set_border(v: Border<Int>): Border<Int> {
		if (border == v) return v;
		_border = v;
		update();
		return v;
	}

}