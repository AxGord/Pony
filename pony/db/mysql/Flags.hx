package pony.db.mysql;

/**
 * MySQL field flags
 * based on field_flags.js (nodejs mysql, author Felix Geisendörfer <felix@debuggable.com>)
 * @author AxGord <axgord@gmail.com>
 */
@:enum abstract Flags(Int) to Int from Int {
	
	// Manually extracted from mysql-5.5.23/include/mysql_com.h
	var NOT_NULL     = 1; /* Field can't be NULL */
	var PRI_KEY      = 2; /* Field is part of a primary key */
	var UNIQUE_KEY   = 4; /* Field is part of a unique key */
	var MULTIPLE_KEY = 8; /* Field is part of a key */
	var BLOB         = 16; /* Field is a blob */
	var UNSIGNED     = 32; /* Field is unsigned */
	var ZEROFILL     = 64; /* Field is zerofill */
	var BINARY       = 128; /* Field is binary   */

	/* The following are only sent to new clients */
	var ENUM             = 256; /* field is an enum */
	var AUTO_INCREMENT   = 512; /* field is a autoincrement field */
	var TIMESTAMP        = 1024; /* Field is a timestamp */
	var SET              = 2048; /* field is a set */
	var NO_DEFAULT_VALUE = 4096; /* Field doesn't have default value */
	var ON_UPDATE_NOW    = 8192; /* Field is set to NOW on UPDATE */
	var NUM              = 32768; /* Field is num (for clients) */

	@:to public function toString():String return toStr[this];
	@:from public static function fromString(s:String):Flags return fromStr[s];
	
	public static var toStr:Map<Int, String>;
	
	public static var fromStr:Map<String, Int>;
	
	private static function __init__():Void {
		toStr = [
			NOT_NULL => 'NOT NULL',
			PRI_KEY => 'PRIMARY KEY',
			UNSIGNED => 'UNSIGNED',
			AUTO_INCREMENT => 'AUTO_INCREMENT'
		];
		fromStr = [for (k in toStr.keys()) toStr[k] => k];
	}
	
	//inline public static function array2string(a:Array<Flags>):String return a.map(toStr.get).join(' ');//hate this :(
	inline public static function array2string(a:Array<Flags>):String return a.map(_array2string).join(' ');
	inline private static function _array2string(f:Flags):String return f.toString();
}