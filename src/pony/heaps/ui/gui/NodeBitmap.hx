package pony.heaps.ui.gui;

import h2d.Bitmap;
import h2d.Object;
import h2d.Tile;
import pony.geom.Point;

class NodeBitmap extends Node {

	public var bitmap(default, null):Bitmap;

	public function new(?tile:Tile, ?parent:Object) {
		super(parent);
		bitmap = new Bitmap(tile, this);
		wh = new Point(tile.width, tile.height);
		changeWh << updateScales;
		changeFlipx << updateScales;
		changeFlipy << updateScales;
	}

	private function updateScales():Void {
		bitmap.scaleX = w / bitmap.tile.width;
		if (flipx) bitmap.scaleX = -bitmap.scaleX;
		bitmap.scaleY = h / bitmap.tile.height;
		if (flipy) bitmap.scaleY = -bitmap.scaleY;
		bitmap.setPosition(flipx ? w : 0, flipy ? h : 0);
	}

	override public function destroy():Void {
		super.destroy();
		bitmap = null;
	}
	
}
