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