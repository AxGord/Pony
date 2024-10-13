package pony.pixi.ui;

import pixi.core.graphics.Graphics;
import pixi.core.sprites.Sprite;
import pixi.extras.BitmapText.BitmapTextStyle;

import pony.color.UColor;
import pony.geom.IWH;
import pony.geom.Point;
import pony.ui.gui.ButtonImgN;
import pony.ui.touch.pixi.Touchable;

/**
 * TextButton
 * @author AxGord <axgord@gmail.com>
 */
class TextButton extends Sprite implements IWH {

	public var core: ButtonImgN;
	public var text(get, set): String;
	public var btext(default, null): BTextLow;
	public var size(get, never): Point<Float>;

	private var color: Array<UColor>;
	private var lines: Array<Graphics>;
	private var prevline: Graphics;

	public function new(color: Array<UColor>, text: String, font: String, ?ansi: String, line: Float = 0, linepos: Float = 0) {
		super();
		this.color = color;
		btext = new BTextLow(text, {font: font, tint: color[0].rgb}, ansi, true);
		btext.interactive = false;
		btext.interactiveChildren = false;
		addChild(btext);
		var g = new Graphics();
		g.lineStyle();
		g.beginFill(0, 0);
		g.drawRect(0, 0, size.x, size.y);
		g.endFill();
		addChildAt(g, 0);
		g.buttonMode = true;
		if (line > 0) {
			lines = [];
			for (c in color) {
				var g = new Graphics();
				g.lineStyle(line, c.rgb, 1 - c.af);

				var pos: Float = 0;
				var step: Bool = false;
				while (pos <= size.x) {
					var end = false;
					if (pos == size.x) {
						end = true;
					}
					if (step) {
						g.lineTo(pos, size.y);
						pos += 5;
					} else {
						g.moveTo(pos, size.y);
						pos += 10;
					}
					if (end)
						break;
					else if (pos > size.x)
						pos = size.x;
					step = !step;
				}
				g.y = linepos;
				g.visible = false;
				addChild(g);
				lines.push(g);
				if (lines.length > 2)
					break;
			}
			prevline = lines[0];
			prevline.visible = true;
		}

		core = new ButtonImgN(new Touchable(g));
		core.onImg << imgHandler;
	}

	private function imgHandler(n: Int): Void {
		n--;
		if (n > color.length)
			n = color.length - 1;
		btext.tint = color[n];

		if (prevline != null) {
			prevline.visible = false;
			prevline = null;
		}
		if (lines[n] != null) {
			lines[n].visible = true;
			prevline = lines[n];
		}
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_text(): String return btext.text;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function set_text(t: String): String return btext.t = t;

	private inline function get_size(): Point<Float> return btext.size;

	public inline function wait(cb: Void -> Void): Void btext.wait(cb);

	public function destroyIWH(): Void destroy();

}