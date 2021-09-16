package pony.heaps;

import hl.Bytes;

@:hlNative('pony') class Native {

	private static inline var SIZE_LEN: UInt = 4;

	private static function get_pref_path(org: Bytes, app: Bytes): Bytes return null;

	@:extern public static inline function getPrefPath(org: String, app: String): String {
		return @:privateAccess String.fromUTF8(get_pref_path(org.toUtf8(), app.toUtf8()));
	}

	private static function get_asset(name: Bytes): Bytes return null;

	@:extern public static inline function getAsset(name: String): haxe.io.Bytes {
		var b: Bytes = get_asset(@:privateAccess name.toUtf8());
		var len: UInt = b.toBytes(SIZE_LEN).getInt32(0);
		return b.toBytes(len + SIZE_LEN).sub(SIZE_LEN, len);
	}

}