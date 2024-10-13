package pony.heaps.ui.gui;

import h2d.Bitmap;
import h2d.Object;
import h2d.Text;
import h2d.Tile;
import h2d.Font.FontChar;
import hxd.Math;
import pony.Pair;
import pony.geom.Point;

/**
 * TextWithSplitter
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class TextWithSplitter extends Text {

	public var glyphsPos(get, never): Array<Point<Float>>;

	private var glyphsPoints: Array<Pair<Point<Float>, Tile>> = [];

	/**
	 * Split text to bitmaps
	 */
	public function split(?parent: Object, ?pos: Point<Float>): Array<Bitmap> {
		return [ for (gp in glyphsPoints) {
			var b: Bitmap = new Bitmap(gp.b, parent);
			b.color = color;
			if (sdfShader != null) b.addShader(sdfShader);
			(pos == null ? gp.a : gp.a + pos).setPosition(b);
			b;
		} ];
	}

	public inline function getFirstGlyphPos(?pos: Point<Float>): Point<Float>
		return @:nullSafety(Off) glyphsPoints[0].a;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_glyphsPos(): Array<Point<Float>>
		return [ for (gp in glyphsPoints) gp.a ];

	public inline function getGlyphsPos(?pos: Point<Float>): Array<Point<Float>>
		return pos == null ? glyphsPos : [ for (gp in glyphsPoints) gp.a + pos ];

	/**
	 * Copy from heaps
	 */
	override private function initGlyphs(text: String, rebuild: Bool = true, handleAlign: Bool = true, ?lines: Array<Int>): Void {
		if (rebuild) {
			glyphsPoints = [];
			glyphs.clear();
		}
		var x: Float = 0.;
		var y: Float = 0.;
		var xMax: Float = 0.;
		var xMin: Float = 0.;
		var prevChar: Int = -1;
		var align: Align = handleAlign ? textAlign : Left;
		switch align {
			case Center, Right, MultilineCenter, MultilineRight:
				lines = [];
				initGlyphs(text, false, false, lines);
				var max: Int = if (align == MultilineCenter || align == MultilineRight) Math.ceil(calcWidth)
					else realMaxWidth < 0 ? 0 : Math.ceil(realMaxWidth);
				var k: Int = align == Center || align == MultilineCenter ? 1 : 0;
				for (i in 0...lines.length) lines[i] = (max - lines[i]) >> k;
				@:nullSafety(Off) x = lines.shift();
				xMin = x;
			default:
		}
		var dl: Float = font.lineHeight + lineSpacing;
		var calcLines: Bool = !handleAlign && !rebuild && lines != null;
		var yMin: Float = 0.;
		var t: String = splitText(text);
		for (i in 0...t.length) {
			@:nullSafety(Off) var cc: Int = t.charCodeAt(i);
			var e: Null<FontChar> = font.getChar(cc);
			var offs: Float = e.getKerningOffset(prevChar);
			var esize: Float = e.width + offs;
			// if the next word goes past the max width, change it into a newline
			if (cc == '\n'.code) {
				if (x > xMax) xMax = x;
				if (calcLines) lines.push(Math.ceil(x));
				switch align {
					case Left:
						x = 0;
					case Right, Center, MultilineCenter, MultilineRight:
						@:nullSafety(Off) x = lines.shift();
						if (x < xMin) xMin = x;
				}
				y += dl;
				prevChar = -1;
			} else {
				if  (e != null) {
					if (rebuild) {
						glyphsPoints.push(new Pair(new Point(x + offs, y), e.t));
						glyphs.add(x + offs, y, e.t);
					}
					if (y == 0 && e.t.dy < yMin) yMin = e.t.dy;
					x += esize + letterSpacing;
				}
				prevChar = cc;
			}
		}
		if (calcLines) lines.push(Math.ceil(x));
		if (x > xMax) xMax = x;
		calcXMin = xMin;
		calcYMin = yMin;
		calcWidth = xMax - xMin;
		calcHeight = y + font.lineHeight;
		calcSizeHeight = y + (font.baseLine > 0 ? font.baseLine : font.lineHeight);
		calcDone = true;
	}

}