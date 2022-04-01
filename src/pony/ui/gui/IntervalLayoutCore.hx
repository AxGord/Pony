package pony.ui.gui;

import pony.geom.Align;
import pony.geom.Border;
import pony.geom.GeomTools;

using pony.Tools;

/**
 * IntervalLayoutCore
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class IntervalLayoutCore<T> extends BaseLayoutCore<T> {

	@:arg private var _interval: Int;
	@:arg private var _vert: Bool = false;
	@:arg private var _border: Border<Int> = 0;
	@:arg private var _align: Align = new Pair(VAlign.Middle, HAlign.Center);
	@:arg private var _limit: Float = 0;

	public var interval(get, set): Int;
	public var vert(get, set): Bool;
	public var border(get, set): Border<Int>;
	public var align(get, set): Align;
	public var limit(get, set): Float;

	override public function update(): Void {
		if (objects == null) return;
		if (!ready) return;
		var pos:Float = 0;
		if (vert) {
			_w = 0;
			pos = border.top;
			var sizes = [for (obj in objects) {
				var objSize = getObjSize(obj);
				if (objSize != null) {
					setYpos(obj, Std.int(pos));
					pos += objSize.y + interval;
					if (objSize.x > _w) _w = objSize.x;
					objSize.x;
				} else {
					0;
				}
			}];
			if (objects.length > 0) pos -= interval;
			_h = pos;
			var hlist = GeomTools.halign(_align, _w, sizes);
			for (i in 0...hlist.length) setXpos(objects[i], Std.int(hlist[i]) + border.left);
		} else {
			_h = 0;
			_w = 0;
			pos = border.left;
			var maxvsize: Float = 0;
			var vPositions: Array<Float> = [];
			var objGroups: Array<Pair<Array<Float>, Array<T>>> = [];
			var objGroup: Array<T> = [];
			var objSizes: Array<Float> = [];
			for (obj in objects) {
				var objSize = getObjSize(obj);
				if (objSize != null) {
					if (limit != 0 && pos + objSize.x > limit - border.right) {
						pos = border.left;
						vPositions.push(_h);
						_h += maxvsize;
						maxvsize = 0;
						objGroups.push(new Pair(objSizes, objGroup));
						objGroup = [];
						objSizes = [];
					}
					setXpos(obj, Std.int(pos));
					if (pos + objSize.x > _w) _w = pos + objSize.x;
					pos += objSize.x + interval;
					if (objSize.y > maxvsize) maxvsize = objSize.y;
					objGroup.push(obj);
					objSizes.push(objSize.y);
				} else {
					setXpos(obj, Std.int(pos));
					objGroup.push(obj);
					objSizes.push(0);
				}
			}
			vPositions.push(_h);
			_h += maxvsize;
			objGroups.push(new Pair(objSizes, objGroup));
			for (i in 0...objGroups.length) {
				var g = objGroups[i];
				var vp = vPositions[i];
				var vlist = GeomTools.valign(_align, _h, g.a);
				for (i in 0...vlist.length) setYpos(g.b[i], Std.int(vlist[i]) + border.top + vp);
			}
		}
		super.update();
	}

	@:extern private inline function get_interval(): Int return _interval;
	@:extern private inline function get_vert(): Bool return _vert;
	@:extern private inline function get_border(): Border<Int> return _border;
	@:extern private inline function get_align(): Align return _align;
	@:extern private inline function get_limit(): Float return _limit;

	@:extern private inline function set_interval(v: Int): Int {
		if (interval == v) return v;
		_interval = v;
		update();
		return v;
	}

	@:extern private inline function set_vert(v: Bool): Bool {
		if (vert == v) return v;
		_vert = v;
		update();
		return v;
	}

	@:extern private inline function set_border(v: Border<Int>): Border<Int> {
		if (border == v) return v;
		_border = v;
		update();
		return v;
	}

	@:extern private inline function set_align(v: Align): Align {
		if (align == v) return v;
		_align = v;
		update();
		return v;
	}

	@:extern private inline function set_limit(v: Float): Float {
		if (limit == v) return v;
		_limit = v;
		update();
		return v;
	}

}