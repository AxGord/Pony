package pony.heaps.ui.gui.slices;

import h2d.Tile;
import h2d.Object;
import pony.geom.Point;

/**
 * Slice3V
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
@:final class Slice3V extends Node {

	private var b: SliceBase;

	public function new(tiles: Array<Tile>, repeat: Bool = false, ?parent: Object) {
		super(new Point(tiles[0].width, GUIUtils.tilesHeightSum(tiles)), parent);
		b = new SliceBase(this, tiles, repeat ? [1] : null);
		changeWh << drawTiles;
		changeFlipx << SliceBase.unsupported;
		changeFlipy << SliceBase.unsupported;
		changeTint << b.setColor;
		drawTiles();
	}

	private function drawTiles(): Void {
		b.clear();
		b.drawTile(0);
		var h0: Float = b.h0;
		var h: Float = h - h0 - b.th(2);
		b.drawTile(1, 0, h0, null, h);
		b.drawTile(2, 0, h0 + h);
	}

}