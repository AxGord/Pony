/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
*
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.db.mysql;

/**
 * MySQL field types
 * based on types.js (nodejs mysql, author Felix Geisendörfer <felix@debuggable.com>)
 * @author AxGord <axgord@gmail.com>
 */
@:enum abstract Types(Int) to Int from Int {
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
	@:from public static function fromString(s:String):Types return fromStr[s];
	
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