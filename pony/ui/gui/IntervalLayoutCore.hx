package pony.ui.gui;

import pony.geom.Align;
import pony.geom.Border;
import pony.geom.GeomTools;

using pony.Tools;

/**
 * IntervalLayoutCore
 * @author AxGord <axgord@gmail.com>
 */
class IntervalLayoutCore<T> extends BaseLayoutCore<T> {
	
	@:arg private var _interval:Int;
	@:arg private var _vert:Bool = false;
	@:arg private var _border:Border<Int> = 0;
	@:arg private var _align:Align = new Pair(VAlign.Middle, HAlign.Center);
	
	public var interval(get, set):Int;
	public var vert(get, set):Bool;
	public var border(get, set):Border<Int>;
	public var align(get, set):Align;
	
	override public function update():Void {
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
			for (p in GeomTools.halign(_align, _w, sizes).pair(objects)) setXpos(p.b, Std.int(p.a) + border.left);
		} else {
			_h = 0;
			pos = border.left;
			var sizes = [for (obj in objects) {
				var objSize = getObjSize(obj);
				if (objSize != null) {
					setXpos(obj, Std.int(pos));
					pos += objSize.x + interval;
					if (objSize.y > _h) _h = objSize.y;
					objSize.y;
				} else {
					0;
				}
			}];
			if (objects.length > 0) pos -= interval;
			_w = pos;
			for (p in GeomTools.valign(_align, _h, sizes).pair(objects)) setYpos(p.b, Std.int(p.a) + border.top);
		}
		super.update();
	}
	
	@:extern inline private function get_interval():Int return _interval;
	@:extern inline private function get_vert():Bool return _vert;
	@:extern inline private function get_border():Border<Int> return _border;
	@:extern inline private function get_align():Align return _align;
	
	@:extern inline private function set_interval(v:Int):Int {
		if (interval == v) return v;
		_interval = v;
		update();
		return v;
	}
	
	@:extern inline private function set_vert(v:Bool):Bool {
		if (vert == v) return v;
		_vert = v;
		update();
		return v;
	}
	
	@:extern inline private function set_border(v:Border<Int>):Border<Int> {
		if (border == v) return v;
		_border = v;
		update();
		return v;
	}
	
	@:extern inline private function set_align(v:Align):Align {
		if (align == v) return v;
		_align = v;
		update();
		return v;
	}
	
}