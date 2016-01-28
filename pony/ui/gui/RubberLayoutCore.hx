/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.geom.Point;

using pony.Tools;

/**
 * RubberLayoutCore
 * @author AxGord <axgord@gmail.com>
 */
class RubberLayoutCore<T> extends BaseLayoutCore<T> {
	
	public var width(default, set):Float;
	public var height(default, set):Float;

	@:arg private var _vert:Bool = false;
	@:arg private var _border:Border<Int> = 0;
	@:arg private var _padding:Bool = true;
	@:arg private var _align:Align = new Pair(VAlign.Middle, HAlign.Center);
	
	public var vert(get, set):Bool;
	public var border(get, set):Border<Int>;
	public var padding(get, set):Bool;
	public var align(get, set):Align;
	
	override public function update():Void {
		if (!ready) return;
		var positions = GeomTools.pointsCeil(GeomTools.center(
				new Point(width, height),
				[for (obj in objects) getObjSize(obj)],
				vert, border, padding, align
			));
		for (p in objects.pair(positions)) {
			setXpos(p.a, p.b.x);
			setYpos(p.a, p.b.y);
		}
		super.update();
	}
	
	override private function get_size():Point<Float> return new Point(width, height);
	
	@:extern inline private function get_vert():Bool return _vert;
	@:extern inline private function get_border():Border<Int> return _border;
	@:extern inline private function get_padding():Bool return _padding;
	@:extern inline private function get_align():Align return _align;
	
	@:extern inline private function set_width(v:Float):Float {
		if (width == v) return v;
		width = v;
		update();
		return v;
	}
	
	@:extern inline private function set_height(v:Float):Float {
		if (height == v) return v;
		height = v;
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
	
	@:extern inline private function set_padding(v:Bool):Bool {
		if (padding == v) return v;
		_padding = v;
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