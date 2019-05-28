package pony.heaps.ui.gui;

import h2d.Tile;

/**
 * GUIUtils
 * @author AxGord <axgord@gmail.com>
 */
class GUIUtils {

	public static inline function tilesWidthSum(t:Array<Tile>):Float return Lambda.fold(t, _tilesWidthSum, 0);
	public static inline function tilesHeightSum(t:Array<Tile>):Float return Lambda.fold(t, _tilesWidthSum, 0);
	public static function _tilesWidthSum(t:Tile, r:Float):Float return r + t.width;
	public static function _tilesHeightSum(t:Tile, r:Float):Float return r + t.height;

}