package pony.db.mysql;

/**
 * MySQL field types
 * based on types.js (nodejs mysql, author Felix Geisendörfer <felix@debuggable.com>)
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) enum #else @:enum #end
abstract Types(Int) to Int from Int {

	public static var toStr: Map<Int, String>;
	public static var fromStr: Map<String, Int>;

	// Manually extracted from mysql-5.5.23/include/mysql_com.h
	// some more info here: http://dev.mysql.com/doc/refman/5.5/en/c-api-prepared-statement-type-codes.html
	final DECIMAL = 0x00; // aka DECIMAL (http://dev.mysql.com/doc/refman/5.0/en/precision-math-decimal-changes.html)
	final TINYINT = 0x01;
	final SMALLINT = 0x02;
	final INT = 0x03;
	final FLOAT = 0x04;
	final DOUBLE = 0x05;
	final NULL = 0x06;
	final TIMESTAMP = 0x07;
	final BIGINT = 0x08;
	final MEDIUMINT = 0x09;
	final DATE = 0x0a;
	final TIME = 0x0b;
	final DATETIME = 0x0c;
	final YEAR = 0x0d;
	final NEWDATE = 0x0e;
	final NEWVARCHAR = 0x0f;
	final BIT = 0x10;
	final NEWDECIMAL = 0xf6;
	final ENUM = 0xf7;
	final SET = 0xf8;
	final TINY_BLOB = 0xf9;
	final MEDIUM_BLOB = 0xfa;
	final LONG_BLOB = 0xfb;
	final TEXT = 0xfc;
	final VARCHAR = 0xfd;
	final CHAR = 0xfe;
	final GEOMETRY = 0xff;

	@:to public function toString(): String return toStr[this];

	@:from public static function fromString(s: String): Types return fromStr[s.toUpperCase()];

	static function __init__(): Void {
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
