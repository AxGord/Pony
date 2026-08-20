package pony.db.mysql;

/**
 * MySQL field flags
 * based on field_flags.js (nodejs mysql, author Felix Geisendörfer <felix@debuggable.com>)
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract Flags(Int) to Int from Int {

	public static var toStr: Map<Int, String>;
	public static var fromStr: Map<String, Int>;

	// Manually extracted from mysql-5.5.23/include/mysql_com.h
	final NOT_NULL = 1; /* Field can't be NULL */
	final PRI_KEY = 2; /* Field is part of a primary key */
	final UNIQUE_KEY = 4; /* Field is part of a unique key */
	final MULTIPLE_KEY = 8; /* Field is part of a key */
	final BLOB = 16; /* Field is a blob */
	final UNSIGNED = 32; /* Field is unsigned */
	final ZEROFILL = 64; /* Field is zerofill */
	final BINARY = 128; /* Field is binary   */

	/* The following are only sent to new clients */
	final ENUM = 256; /* field is an enum */
	final AUTO_INCREMENT = 512; /* field is a autoincrement field */
	final TIMESTAMP = 1024; /* Field is a timestamp */
	final SET = 2048; /* field is a set */
	final NO_DEFAULT_VALUE = 4096; /* Field doesn't have default value */
	final ON_UPDATE_NOW = 8192; /* Field is set to NOW on UPDATE */
	final NUM = 32768; /* Field is num (for clients) */

	@:to public function toString(): String return toStr[this];

	// inline public static function array2string(a:Array<Flags>):String return a.map(toStr.get).join(' ');//hate this :(
	public static inline function array2string(a: Array<Flags>): String return a.map(_array2string).join(' ');

	@:from public static function fromString(s: String): Flags return fromStr[s];

	private static inline function _array2string(f: Flags): String return f.toString();

	private static function __init__(): Void {
		toStr = [
			NOT_NULL => 'NOT NULL',
			PRI_KEY => 'PRIMARY KEY',
			UNSIGNED => 'UNSIGNED',
			AUTO_INCREMENT => 'AUTO_INCREMENT'
		];
		fromStr = [for (k in toStr.keys()) toStr[k] => k];
	}

}
