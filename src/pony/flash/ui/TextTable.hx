package pony.flash.ui;

import flash.display.DisplayObjectContainer;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.LineScaleMode;
import flash.display.CapsStyle;
import flash.display.JointStyle;
import flash.text.TextField;
import flash.text.TextFormat;
import pony.color.Color;
import pony.color.UColor;
import pony.geom.Point.IntPoint;
import pony.geom.Rect.IntRect;
import pony.ui.gui.FontStyle;
import pony.ui.gui.TextTableCore;

/**
 * Table
 * @author AxGord <axgord@gmail.com>
 */
class TextTable extends TextTableCore {

	private var area: DisplayObjectContainer;
	private var shape: Shape;
	private var g(get, never): Graphics;

	public function new(area: DisplayObjectContainer) {
		super();
		this.area = area;
		createShape();
	}

	private inline function createShape(): Void {
		shape = new Shape();
		area.addChild(shape);
	}

	private inline function get_g(): Graphics
		return shape.graphics;

	#if (haxe_ver < 4.2) override #end
	private function drawBG(r: IntRect, color: UColor): Void {
		g.lineStyle();
		g.beginFill(color);
		g.drawRect(r.getX(), r.getY(), r.getWidth(), r.getHeight());
		g.endFill();
	}

	#if (haxe_ver < 4.2) override #end
	private function drawText(point: IntRect, text: String, style: FontStyle): Void {
		var tf = new TextField();
		tf.text = text;
		tf.selectable = false;
		tf.setTextFormat(new TextFormat(style.font, style.size, style.color, style.bold, style.italic, style.underline));
		tf.x = point.x;
		tf.y = point.y;
		area.addChild(tf);
	}

	#if (haxe_ver < 4.2) override #end
	private function clear(): Void {
		area.removeChild(shape);
		createShape();
	}

}