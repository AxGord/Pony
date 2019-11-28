package pony.heaps.ui.gui.slices;

import h3d.Vector;
import h2d.Graphics;
import h2d.Bitmap;
import h2d.TileGroup;
import h2d.Tile;
import h2d.Drawable;
import h2d.Object;
import pony.geom.Point;
import pony.magic.HasLink;

/**
 * SliceBase
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
@:final class SliceBase implements HasLink {

	private var tiles: Array<Tile>;
	private var groups: Map<Int, TileGroup> = new Map();
	private var solo: Map<Int, Bitmap> = new Map();
	private var wrap: Map<Int, Graphics> = new Map();

	public var twsum(link, never): Float = GUIUtils.tilesWidthSum(tiles);
	public var thsum(link, never): Float = GUIUtils.tilesHeightSum(tiles);
	public var w0(link, never): Float = tw(0);
	public var h0(link, never): Float = th(0);

	public function new(target: Object, tiles: Array<Tile>, ?wrap: Array<Int>) {
		this.tiles = tiles;
		if (wrap == null) wrap = [];
		var soloTexture: Map<Int, Int> = new Map();
		var i: Int = 0;
		for (t in tiles) {
			var id: Int = t.getTexture().id;
			if (!groups.exists(id)) {
				var s: Null<Int> = soloTexture[id];
				if (s != null) {
					soloTexture.remove(id);
					groups[id] = new TileGroup(t, target);
				} else if (wrap.indexOf(i) == -1) {
					soloTexture[id] = i;
				}
			}
			i++;
		}
		for (i in soloTexture)
			solo[i] = new Bitmap(tiles[i], target);
		for (i in wrap) {
			var g: Graphics = new Graphics(target);
			g.tileWrap = true;
			g.beginTileFill(tiles[i]);
			this.wrap[i] = g;
		}
	}

	public function setColor(v: Vector): Void {
		for (s in solo) s.color = v;
		for (w in wrap) w.color = v;
		for (g in groups) g.color = v;
	}

	public static function unsupported(): Void throw 'Unsupported';

	@:extern public inline function tw(n: Int): Float return tiles[n].width;
	@:extern public inline function th(n: Int): Float return tiles[n].height;

	public function clear(): Void {
		for (s in solo) s.visible = false;
		for (w in wrap) w.clear();
		for (g in groups) g.clear();
	}

	@:extern public inline function drawTile(
		n: Int, x: Float = 0, y: Float = 0, ?w: Float, ?h: Float, flipx: Bool = false, flipy: Bool = false
	): Void {
		if ((w == null || w > 0) && (h == null || h > 0)) _drawTile(n, x, y, w, h, flipx, flipy);
	}

	private function _drawTile(n: Int, x: Float = 0, y: Float = 0, ?w: Float, ?h: Float, flipx: Bool = false, flipy: Bool = false): Void {
		var tile: Tile = tiles[n];
		if (w == null)
			w = tile.width;
		if (h == null)
			h = tile.height;
		var wr: Null<Graphics> = wrap[n];
		if (wr != null) {
			wr.drawRect(0, 0, w, h);
			wr.setPosition(flipx ? x + w : x, flipy ? y + h : y);
			wr.scaleX = flipx ? -1 : 1;
			wr.scaleY = flipy ? -1 : 1;
		} else {
			var b: Null<Bitmap> = solo[n];
			var sx: Float = w / tile.width;
			var sy: Float = h / tile.height;
			if (b != null) {
				b.visible = true;
				b.setPosition(flipx ? x + w : x, flipy ? y + h : y);
				b.scaleX = flipx ? -sx : sx;
				b.scaleY = flipy ? -sy : sy;
			} else {
				var id: Int = tile.getTexture().id;
				@:nullSafety(Off) var g: TileGroup = groups[id];
				g.addTransform(
					flipx ? x + w : x,
					flipy ? y + h : y,
					flipx ? -sx : sx,
					flipy ? -sy : sy,
					0,
					tile
				);
			}
		}
	}

}