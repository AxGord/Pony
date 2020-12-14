package pony.heaps;

import h2d.Tile;
import hxd.res.Any;
import haxe.crypto.Base64;

/**
 * HeapsUtils
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class HeapsUtils {

	public static function base64ToTile(s: String): Tile {
		var a: Array<String> = s.split(',');
		return Any.fromBytes(a[0].split(':')[0], Base64.decode(a[1], false)).toTile();
	}

}