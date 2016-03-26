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
import pony.geom.GeomTools;

using pony.Tools;

/**
 * IntervalLayoutCore
 * @author AxGord <axgord@gmail.com>
 */
class AlignLayoutCore<T> extends BaseLayoutCore<T> {
	
	@:arg private var _align:Align = new Pair(VAlign.Middle, HAlign.Center);
	
	public var align(get, set):Align;
	
	override public function update():Void {
		if (objects == null) return;
		if (!ready) return;
		if (align.horizontal != null) {
			_w = 0;
			var sizesX = [for (obj in objects) {
				var s = getObjSize(obj).x;
				if (s > _w) _w = s;
				s;
			}];
			for (p in GeomTools.halign(align, _w, sizesX).pair(objects)) setXpos(p.b, Std.int(p.a));
		} else {
			_h = 0;
			var sizesY = [for (obj in objects) {
				var s = getObjSize(obj).y;
				if (s > _h) _h = s;
				s;
			}];
			for (p in GeomTools.valign(align, _h, sizesY).pair(objects)) setYpos(p.b, Std.int(p.a));
		}
		super.update();
	}
	
	@:extern inline private function get_align():Align return _align;
	
	@:extern inline private function set_align(v:Align):Align {
		if (align == v) return v;
		_align = v;
		update();
		return v;
	}
	
}