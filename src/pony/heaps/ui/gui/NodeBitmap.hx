package pony.heaps.ui.gui;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import h3d.Vector;
import pony.geom.Point;

/**
 * NodeBitmap
 * @author AxGord <axgord@gmail.com>
 */
@:final class NodeBitmap extends Node {

	public var bitmap(default, null): Bitmap;

	public function new(?tile: Tile, ?parent: Object) {
		super(new Point(tile.width, tile.height), parent);
		bitmap = new Bitmap(tile, this);
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
		bitmap.setPosition(flipx ? w : 0, flipy ? h : 0);
	}

	private function updateColor(v: Vector): Void {
		bitmap.color = v;
	}

	override public function destroy(): Void {
		super.destroy();
		bitmap = null;
	}

}
