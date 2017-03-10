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
package pony.pixi.ui;

import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pixi.extras.BitmapText;
import pony.color.UColor;
import pony.geom.Align.HAlign;
import pony.geom.Align.VAlign;
import pony.geom.GeomTools;
import pony.geom.Point;
import pony.geom.Point.IntPoint;
import pony.geom.Rect.IntRect;
import pony.Pair;
import pony.ui.gui.FontStyle;
import pony.ui.gui.TextTableCore;

/**
 * TextTable
 * @author AxGord <axgord@gmail.com>
 */
class TextTable extends TextTableCore {
	
	private var graphics:Graphics;
	private var target:Sprite;
	private var texts:Array<BitmapText>;
	
	public function new(target:Sprite) {
		super();
		this.target = target;
		graphics = new Graphics();
		target.addChild(graphics);
		create();
	}
	
	private function create():Void {
		texts = [];
	}
	
	override private function drawBG(r:IntRect, color:UColor):Void {
		if (color.a == 0xFF) return;
		graphics.lineStyle();
		graphics.beginFill(color.rgb, color.invertAlpha.af);
		graphics.drawRect(r.getX(), r.getY(), r.getWidth(), r.getHeight());
		graphics.endFill();
	}
	
	override function drawLine(a:IntPoint, b:IntPoint, color:UColor, size:Int):Void {
		if (color.a == 0xFF) return;
		graphics.lineStyle(size, color.rgb, color.invertAlpha.af);
		var d = size / 2;
		if (a.x == b.x) {
			graphics.moveTo(a.x+d, a.y);
			graphics.lineTo(b.x+d, b.y);
		} else {
			graphics.moveTo(a.x, a.y+d);
			graphics.lineTo(b.x, b.y+d);
		}
	}
	
	override private function drawText(point:IntRect, text:String, style:FontStyle):Void {
		var t = new BitmapText(text, { font:style.size+'px ' + style.font, tint:style.color } );
		var align = if (style.border != null && style.align == null)
			new Pair(VAlign.Top, HAlign.Left);
		else 
			style.align;
		
		if (align != null) {
			var pos = GeomTools.center(new Point<Float>(point.width, point.height), [new Point(t.width, t.height)], style.border, false, align)[0];
			t.x = point.x + pos.x;
			t.y = point.y + pos.y;
		} else {
			t.x = point.x;
			t.y = point.y;
		}
		texts.push(t);
		target.addChild(t);
	}
	
	override private function clear():Void {
		for (t in texts) {
			target.removeChild(t);
			t.destroy();
		}
		graphics.clear();
		create();
	}
	
	public function destroy():Void {
		for (t in texts) {
			target.removeChild(t);
			t.destroy();
		}
		texts = null;
		target.removeChild(graphics);
		graphics.destroy();
		graphics = null;
		target = null;
	}
	
}