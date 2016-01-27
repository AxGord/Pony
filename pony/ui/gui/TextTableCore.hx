/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import pony.color.UColor;
import pony.geom.Direction;
import pony.geom.Point.IntPoint;
import pony.geom.Point.Point;
import pony.geom.Rect.IntRect;
import pony.geom.Rect.Rect;
import pony.magic.HasAbstract;
import pony.math.MathTools;
import pony.Pair.Pair;

using pony.Tools;

typedef TableContent = Array < Array<String> > ;

/**
 * TableCore
 * @author AxGord <axgord@gmail.com>
 */
class TextTableCore implements HasAbstract {
	
	public var data(default, set):TableContent;
	
	private function new() {}
	
	public function set_data(d:TableContent):TableContent {
		if (data != null) clear();
		data = d;
		if (d != null) draw();
		return d;
	}
	
	private function drawLine(a:IntPoint, b:IntPoint, color:UColor, size:Int):Void {
		if (a.x == b.x) drawBG({x:a.x, y:a.y, width: size, height: MathTools.cabs(b.y-a.y)}, color);
		else drawBG({x:a.x, y:a.y, width: MathTools.cabs(b.x-a.x), height: size}, color);
	}
	@:abstract private function drawBG(r:IntRect, color:UColor):Void;
	@:abstract private function drawText(point:IntPoint, text:String, style:FontStyle):Void;
	@:abstract private function clear():Void;
	
	public dynamic function borderStyle(point:IntPoint, direct:Direction):Pair<Int,UColor> return new Pair(1,new UColor(0));
	public dynamic function bgStyle(point:IntPoint):Pair<IntPoint, UColor> return new Pair({x:100,y:20}, new UColor(0xFFFFFF));
	public dynamic function fontStyle(point:IntPoint):FontStyle
		return {font:'Arial', size: 14, color: 0, bold: false, italic:false, underline: false};
	
	public function draw():Void {
		var rl:Int = data.length-1;
		var sdy:Int = 0;
		for (r in data.kv()) {
			var dx:Int = 0;
			var mdy:Int = sdy;
			var cl:Int = r.value.length-1;
			for (c in r.value.kv()) {
				var dy:Int = sdy;
				var point:IntPoint = { x: c.key, y: r.key };
				var bg = bgStyle(point);
				var top = borderStyle(point, Direction.up);
				var left = borderStyle(point, Direction.left);
				var right = borderStyle(point, Direction.right);
				var bottom = borderStyle(point, Direction.down);
				drawLine( { x: dx, y: dy }, { x: dx + bg.a.x + left.a, y: dy }, top.b, top.a);
				dy += top.a;
				drawLine( { x: dx, y: dy }, { x: dx, y: dy + bg.a.y }, left.b, left.a);
				dx += left.a;
				drawBG( { x:dx, y:dy, width:bg.a.x, height:bg.a.y }, bg.b);
				var tf = fontStyle(point);
				drawText({x: dx, y: dy},c.value, tf);
				if (cl == c.key)
				drawLine( { x: dx + bg.a.x, y: dy-top.a }, { x: dx + bg.a.x, y: dy + bg.a.y }, right.b, right.a);
				dy += bg.a.y;
				if (rl == r.key)
				drawLine( { x: dx - left.a, y: dy }, { x: dx + bg.a.x + right.a, y: dy }, bottom.b, bottom.a);
				dx += bg.a.x;
				if (dy > mdy) mdy = dy;
			}
			sdy = mdy;
		}
	}
	
}