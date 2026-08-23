package pony.heaps.ui.gui;

import h2d.Text;
import h2d.Tile;
import pony.geom.Point;

using Lambda;

/**
 * GUIUtils
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class GUIUtils {

	public static inline function tilesWidthSum(t: Array<Tile>): Float return t.fold(_tilesWidthSum, 0);

	public static inline function tilesHeightSum(t: Array<Tile>): Float return t.fold(_tilesWidthSum, 0);

	/**
	 * The box a layout reserves for a text: the width it was given a `maxWidth` for when it has
	 * one, and the line box rather than the ink of the current string. Both make the box independent
	 * of the content, so a text filled in after the layout ran keeps the place it was laid out in,
	 * and a label centres on its baseline instead of on whichever glyphs happen to be in it.
	 */
	public static inline function textSize(t: Text): Point<Float> return new Point<Float>(t.maxWidth ?? t.textWidth, t.textHeight);

	public static function _tilesWidthSum(t: Tile, r: Float): Float return r + t.width;

	public static function _tilesHeightSum(t: Tile, r: Float): Float return r + t.height;

}
