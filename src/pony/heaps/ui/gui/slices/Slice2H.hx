package pony.heaps.ui.gui.slices;

import h2d.Object;
import h2d.Tile;
import pony.geom.Point;

/**
 * Slice2H
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
final class Slice2H extends Node {

	private final b: SliceBase;

	public function new(tiles: Array<Tile>, repeat: Bool = false, ?parent: Object) {
		tiles.push(tiles[0]);
		super(new Point(GUIUtils.tilesWidthSum(tiles), tiles[0].height), parent);
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
		final w0: Float = b.w0;
		final w: Float = w - w0 * 2;
		b.drawTile(1, w0, 0, w);
		b.drawTile(2, w0 + w, true);
	}

}
