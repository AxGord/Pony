package pony.flash.ui;
import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.text.TextField;
import flash.text.TextFormat;
import pony.geom.Point.IntPoint;
import pony.geom.Rect.IntRect;
import pony.ui.FontStyle;
import pony.ui.TableCore;

/**
 * Table
 * @author AxGord <axgord@gmail.com>
 */
class Table extends TableCore {

	private var area:DisplayObjectContainer;
	private var shape:Shape;
	private var g(get,never):Graphics;
	
	public function new(area:DisplayObjectContainer) {
		super();
		this.area = area;
		shape = new Shape();
		area.addChild(shape);
	}
	
	private inline function get_g():Graphics return shape.graphics;

	override private function drawBG(r:IntRect, color:Int):Void {
		g.lineStyle();
		g.beginFill(color);
		g.drawRect(r.getX(), r.getY(), r.getWidth(), r.getHeight());
		g.endFill();
	}
	
	override private function drawText(point:IntPoint, text:String, style:FontStyle):Void {
		var tf = new TextField();
		tf.text = text;
		trace(style);
		tf.selectable = false;
		tf.setTextFormat(new TextFormat(style.font, style.size, style.color, style.bold, style.italic, style.underline));
		tf.x = point.x;
		tf.y = point.y;
		area.addChild(tf);
	}
	
}