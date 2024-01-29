package pony.heaps.ui.gui;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;

#if (heaps >= '2.0.0')
import h3d.Vector4 as Vector;
#else
import h3d.Vector;
#end

import pony.geom.Border;
import pony.geom.Point;

/**
 * NodeBitmap
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
@:final class NodeBitmap extends Node {

	public var bitmap(default, null): Bitmap;

	public function new(tile: Tile, ?size: Point<Int>, ?border: Border<Int>, ?parent: Object) {
		super(size != null ? size : new Point(tile.width, tile.height), border, parent);
		bitmap = new Bitmap(tile, this);
		if (size != null) {
			bitmap.setPosition((size.x - tile.width) / 2, (size.y - tile.height) / 2);
		}
		if (border != null) {
			bitmap.x += border.left;
			bitmap.y += border.top;
		}
		changeWh << updateScales;
		changeFlipx << updateScales;
		changeFlipy << updateScales;
		changeTint << updateColor;
	}

	private function updateScales(): Void {
		bitmap.scaleX = w / bitmap.tile.width;
		if (flipx) bitmap.scaleX = -bitmap.scaleX;
		bitmap.scaleY = h / bitmap.tile.height;
		if (flipy) bitmap.scaleY = -bitmap.scaleY;
		bitmap.setPosition((flipx ? w : 0) + border.left, (flipy ? h : 0 + border.top));
	}

	private function updateColor(v: Vector): Void {
		bitmap.color = v;
	}

	override public function destroy(): Void {
		super.destroy();
		@:nullSafety(Off) bitmap = null;
	}

}
