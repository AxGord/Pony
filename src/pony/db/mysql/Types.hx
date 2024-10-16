package pony.db.mysql;

/**
 * MySQL field types
 * based on types.js (nodejs mysql, author Felix Geisendörfer <felix@debuggable.com>)
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract Types(Int) to Int from Int {
	// Manually extracted from mysql-5.5.23/include/mysql_com.h
	// some more info here: http://dev.mysql.com/doc/refman/5.5/en/c-api-prepared-statement-type-codes.html
	var DECIMAL     = 0x00; // aka DECIMAL (http://dev.mysql.com/doc/refman/5.0/en/precision-math-decimal-changes.html)
	var TINYINT     = 0x01;
	var SMALLINT    = 0x02;
	var INT         = 0x03;
	var FLOAT       = 0x04;
	var DOUBLE      = 0x05;
	var NULL        = 0x06;
	var TIMESTAMP   = 0x07;
	var BIGINT      = 0x08;
	var MEDIUMINT   = 0x09;
	var DATE        = 0x0a;
	var TIME        = 0x0b;
	var DATETIME    = 0x0c;
	var YEAR        = 0x0d;
	var NEWDATE     = 0x0e;
	var NEWVARCHAR  = 0x0f;
	var BIT         = 0x10;
	var NEWDECIMAL  = 0xf6;
	var ENUM        = 0xf7;
	var SET         = 0xf8;
	var TINY_BLOB   = 0xf9;
	var MEDIUM_BLOB = 0xfa;
	var LONG_BLOB   = 0xfb;
	var TEXT        = 0xfc;
	var VARCHAR     = 0xfd;
	var CHAR        = 0xfe;
	var GEOMETRY    = 0xff;

	@:to public function toString():String return toStr[this];
	@:from public static function fromString(s:String):Types return fromStr[s.toUpperCase()];

	public static var toStr:Map<Int, String>;

	public static var fromStr:Map<String, Int>;

	static function __init__():Void {
		toStr = [
			DECIMAL => 'DECIMAL',
			TINYINT => 'TINYINT',
			SMALLINT => 'SMALLINT',
			INT => 'INT',
			FLOAT => 'FLOAT',
			DOUBLE => 'DOUBLE',
			NULL => 'NULL',
			TIMESTAMP => 'TIMESTAMP',
			BIGINT => 'BIGINT',
			MEDIUMINT => 'MEDIUMINT',
			DATE => 'DATE',
			TIME => 'TIME',
			DATETIME => 'DATETIME',
			YEAR => 'YEAR',
			NEWDATE => 'NEWDATE',
			NEWVARCHAR => 'VARCHAR',
			BIT => 'BIT',
			NEWDECIMAL => 'NEWDECIMAL',
			ENUM => 'ENUM',
			SET => 'SET',
			TINY_BLOB => 'TINY_BLOB',
			MEDIUM_BLOB => 'MEDIUM_BLOB',
			LONG_BLOB => 'LONG_BLOB',
			TEXT => 'TEXT',
			VARCHAR => 'VARCHAR',
			CHAR => 'CHAR',
			GEOMETRY => 'GEOMETRY'
		];
		fromStr = [for (k in toStr.keys()) toStr[k] => k];
	}
}