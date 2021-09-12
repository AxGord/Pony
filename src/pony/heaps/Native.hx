package pony.heaps;

import hl.Bytes;

@:hlNative('pony') class Native {

	private static function get_pref_path(org: Bytes, app: Bytes): Bytes return null;

	public static function getPrefPath(org: String, app: String): String {
		return @:privateAccess String.fromUTF8(get_pref_path(org.toUtf8(), app.toUtf8()));
	}

}