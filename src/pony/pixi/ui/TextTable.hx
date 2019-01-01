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