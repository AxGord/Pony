package pony.heaps.ui.gui.slices;

import h2d.Tile;
import h2d.Object;
import pony.geom.Point;

/**
 * Slice3H
 * @author AxGord <axgord@gmail.com>
 */
@:final class Slice3H extends Node {

	private var b:SliceBase;

	public function new(tiles:Array<Tile>, ?repeat:Bool, ?parent:Object) {
		super(new Point(GUIUtils.tilesWidthSum(tiles), tiles[0].height), parent);
		b = new SliceBase(this, tiles, repeat ? [1] : null);
		changeWh << drawTiles;
		changeFlipx << SliceBase.unsupported;
		changeFlipy << SliceBase.unsupported;
		drawTiles();
	}

	private function drawTiles():Void {
		b.clear();
		b.drawTile(0);
		var w0:Float = b.w0;
		var w:Float = w - w0 - b.tw(2);
		b.drawTile(1, w0, 0, w);
		b.drawTile(2, w0 + w);
	}

}