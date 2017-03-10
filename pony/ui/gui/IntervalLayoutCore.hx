/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
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
				setYpos(obj, Std.int(pos));
				pos += objSize.y + interval;
				if (objSize.x > _w) _w = objSize.x;
				objSize.x;
			}];
			if (objects.length > 0) pos -= interval;
			_h = pos;
			for (p in GeomTools.halign(_align, _w, sizes).pair(objects)) setXpos(p.b, Std.int(p.a) + border.left);
		} else {
			[];
			_h = 0;
			pos = border.left;
			var sizes = [for (obj in objects) {
				var objSize = getObjSize(obj);
				setXpos(obj, Std.int(pos));
				pos += objSize.x + interval;
				if (objSize.y > _h) _h = objSize.y;
				objSize.y;
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