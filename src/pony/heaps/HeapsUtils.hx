package pony.heaps;

import haxe.crypto.Base64;

import h2d.Tile;

import hxd.Res;
import hxd.res.Any;
import hxd.res.Loader;

import pony.heaps.fs.FS;

/**
 * HeapsUtils
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class HeapsUtils {

	public static function base64ToTile(s: String): Tile {
		var a: Array<String> = s.split(',');
		return Any.fromBytes(a[0].split(':')[0], Base64.decode(a[1], false)).toTile();
	}

	public static inline function initResLoader(rootFiles: Array<String>): Void Res.loader = new Loader(new FS(rootFiles));

}