package pony.heaps;

#if sys
import hl.Bytes;

/**
 * Native
 * @author AxGord <axgord@gmail.com>
 */
#if mobile @:hlNative('pony') #end final class Native {

	#if mobile

	public static inline var BUFFER_SIZE: Int = 1024 * 1000;

	private static inline var SIZE_LEN: UInt = 4;

	public static var assetBytesAvailable(default, null): Int = 0;

	private static function get_asset(name: Bytes): Int return 0;
	private static function get_asset_bytes(len: Int): Bytes return null;
	private static function finish_get_asset(): Void {}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function getAsset(name: String): Void {
		assetBytesAvailable =  get_asset(@:privateAccess name.toUtf8());
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function getAssetBytes(): haxe.io.Bytes {
		var s: Int = assetBytesAvailable > BUFFER_SIZE ? BUFFER_SIZE : assetBytesAvailable;
		var b: Bytes = get_asset_bytes(s);
		var r: haxe.io.Bytes = b.toBytes(s);
		assetBytesAvailable -= BUFFER_SIZE;
		if (assetBytesAvailable < 0) assetBytesAvailable = 0;
		return r;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function finishGetAsset(): Void finish_get_asset();

	private static function get_internal_storage_path(): Bytes return null;

	#end

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function getPrefPath(org: String, app: String): String {
		#if mac
		return '${Sys.getEnv('HOME')}/Library/Application Support/$org/$app/';
		#elseif win
		return '${Sys.getEnv('AppData')}/$org/$app/';
		#elseif mobile
		return @:privateAccess String.fromUTF8(get_internal_storage_path());
		#else
		throw 'Not supported for current platform';
		#end
	}

	#if sys

	private static function get_sdl_error(): Bytes return null;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public static inline function getSdlError(): String return @:privateAccess String.fromUTF8(get_sdl_error());

	#end

}
#end