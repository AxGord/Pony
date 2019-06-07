package pony.heaps.ui.gui.slices;

import h2d.Tile;
import h2d.Object;
import pony.geom.Point;

/**
 * Slice9
 * @author AxGord <axgord@gmail.com>
 */
@:final class Slice9 extends Node {

	private var b:SliceBase;

	public function new(tiles:Array<Tile>, ?repeat:Bool, ?parent:Object) {
		super(new Point(
			GUIUtils.tilesWidthSum(tiles.slice(0, 3)),
			tiles[0].height + tiles[3].height + tiles[6].height
			), parent);
		b = new SliceBase(this, tiles, repeat ? [1, 3, 4, 5, 7] : null);
		changeWh << drawTiles;
		changeFlipx << SliceBase.unsupported;
		changeFlipy << SliceBase.unsupported;
		changeTint << b.setColor;
		drawTiles();
	}

	private function drawTiles():Void {
		b.clear();
		b.drawTile(0);
		var w0:Float = b.w0;
		var h0:Float = b.h0;
		var w:Float = w - w0 - b.tw(2);
		var h:Float = h - h0 - b.th(6);
		b.drawTile(1, w0, 0, w);
		b.drawTile(2, w0 + w);
		b.drawTile(3, 0, h0, null, h);
		b.drawTile(4, w0, h0, w, h);
		b.drawTile(5, w0 + w, h0, null, h);
		b.drawTile(6, 0, h0 + h);
		b.drawTile(7, w0, h0 + h, w);
		b.drawTile(8, w0 + w, h0 + h);
	}

}