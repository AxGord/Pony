package pony.ui.gui;

import pony.geom.Align;
import pony.geom.Border;
import pony.geom.GeomTools;
import pony.geom.Point;

using pony.Tools;

/**
 * RubberLayoutCore
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class RubberLayoutCore<T> extends BaseLayoutCore<T> {

	public var width(default, set): Float = 0;
	public var height(default, set): Float = 0;

	@:arg private var _vert: Bool = false;
	@:arg private var _border: Border<Int> = 0;
	@:arg private var _padding: Bool = true;
	@:arg private var _align: Align = new Pair(VAlign.Middle, HAlign.Center);
	@:arg private var _limit: Bool = false;

	public var vert(get, set): Bool;
	public var border(get, set): Border<Int>;
	public var padding(get, set): Bool;
	public var align(get, set): Align;
	public var limit(get, set): Bool;

	override public function update(): Void {
		if (objects == null) return;
		if (!ready) return;
		if (limit) {
			var line: Float = 0;
			var groupSize: Array<Float> = [];
			var currentSize: Float = 0;
			var objGroups: Array<Pair<Array<T>, Array<Point<Float>>>> = [];
			var objGroup: Array<T> = [];
			var objSizes: Array<Point<Float>> = [];
			for (obj in objects) {
				var v: Point<Float> = getObjSize(obj);
				line += vert ? v.y : v.x;
				if (line > (vert ? height : width)) {
					line = vert ? v.y : v.x;
					objGroups.push(new Pair(objGroup, objSizes));
					objGroup = [];
					objSizes = [];
					groupSize.push(currentSize);
					currentSize = 0;
				}
				if ((vert ? v.x : v.y) > currentSize) currentSize = vert ? v.x : v.y;
				objGroup.push(obj);
				objSizes.push(v);
			}
			objGroups.push(new Pair(objGroup, objSizes));
			groupSize.push(currentSize);
			var xd: Float = 0;
			var yd: Float = 0;
			var lastPositions: Null<Array<Point<Float>>> = null;
			for (i in 0...objGroups.length) {
				var group: Pair<Array<T>, Array<Point<Float>>> = objGroups[i];
				var s: Float = groupSize[i];
				var positions: Array<IntPoint> = GeomTools.pointsCeil(GeomTools.center(
					new Point(vert ? s : width, !vert ? s : height),
					group.b, vert, border, padding,
					new Pair(!vert ? align.vertical : VAlign.Middle, vert ? align.horizontal : HAlign.Center)
				));
				var xSetted: Bool = false;
				var ySetted: Bool = false;
				if (lastPositions != null && group.a.length != lastPositions.length) {
					if (!vert) switch align.horizontal {
						case HAlign.Left:
							for (i in 0...group.a.length) setXpos(group.a[i], lastPositions[i].x);
							xSetted = true;
						case HAlign.Right:
							for (i in 0...group.a.length) setXpos(group.a[i], @:nullSafety(Off) lastPositions.pop().x);
							xSetted = true;
						case _:
					}
				}
				final savePos: Bool = !xSetted && !ySetted && i == objGroups.length - 2;
				if (savePos) lastPositions = [];
				for (p in group.a.pair(positions)) {
					if (!xSetted) setXpos(p.a, xd + p.b.x);
					if (!ySetted) setYpos(p.a, yd + p.b.y);
					if (savePos) @:nullSafety(Off) lastPositions.push(new Point(xd + p.b.x, yd + p.b.y));
				}
				xd += vert ? s : 0;
				yd += !vert ? s : 0;
			}
		} else {
			var positions: Array<IntPoint> = GeomTools.pointsCeil(GeomTools.center(
				size, [ for (obj in objects) getObjSize(obj) ], vert, border, padding, align
			));
			for (p in objects.pair(positions)) {
				setXpos(p.a, p.b.x);
				setYpos(p.a, p.b.y);
			}
		}
		super.update();
	}

	override private function get_size(): Point<Float> return new Point(width, height);

	@:extern private inline function get_vert(): Bool return _vert;
	@:extern private inline function get_border(): Border<Int> return _border;
	@:extern private inline function get_padding(): Bool return _padding;
	@:extern private inline function get_align(): Align return _align;
	@:extern private inline function get_limit(): Bool return _limit;

	@:extern private inline function set_width(v: Float): Float {
		if (width == v) return v;
		width = v;
		update();
		return v;
	}

	@:extern private inline function set_height(v: Float): Float {
		if (height == v) return v;
		height = v;
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

	@:extern private inline function set_padding(v: Bool): Bool {
		if (padding == v) return v;
		_padding = v;
		update();
		return v;
	}

	@:extern private inline function set_align(v: Align): Align {
		if (align == v) return v;
		_align = v;
		update();
		return v;
	}

	@:extern private inline function set_limit(v: Bool): Bool {
		if (limit == v) return v;
		_limit = v;
		update();
		return v;
	}

}