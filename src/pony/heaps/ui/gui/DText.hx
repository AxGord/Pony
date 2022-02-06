package pony.heaps.ui.gui;

import h2d.Font;
import h2d.Object;
import h2d.Text;

import h3d.Vector;

import pony.color.UColor;
import pony.geom.IWH;
import pony.geom.Point;

/**
 * Text with disable function
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety class DText extends Text implements IWH {

	public var enabled(default, set): Bool = true;
	public var size(get, never): Point<Float>;

	private var normalColor: Vector = Vector.fromColor(0xFFFFFFFF);
	private var disabledColor: Vector = Vector.fromColor(0x70707070);

	public function new(font: Font, ?disabledColor: UColor, disable: Bool = false, ?parent: Object ) {
		super(font, parent);
		if (disabledColor != null)
			this.disabledColor = Vector.fromColor(disabledColor.invertAlpha.argb);
		if (disable) this.disable();
	}

	public inline function set_enabled(v: Bool): Bool {
		if (v != enabled) {
			enabled = v;
			color = enabled ? normalColor : disabledColor;
		}
		return v;
	}

	public inline function enable(): Void enabled = true;
	public inline function disable(): Void enabled = false;

	override private function set_textColor(c: Int): Int {
		normalColor = Vector.fromColor((c: UColor).invertAlpha.argb);
		if (enabled) color = normalColor;
		return c;
	}

	public function wait(cb: Void -> Void): Void cb();
	private function get_size(): Point<Float> return new Point<Float>(textWidth * scaleX, textHeight * scaleY);
	public function destroyIWH(): Void {}

}