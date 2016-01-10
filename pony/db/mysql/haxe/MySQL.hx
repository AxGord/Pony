/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.db.mysql.haxe;

#if (cpp || neko || php)

import pony.db.SQLBase;
import haxe.PosInfos;
import pony.db.ISQL;
import pony.db.mysql.Config;
import pony.events.Waiter;
import pony.Logable;
import pony.Stream;
import sys.db.Connection;
import sys.db.Mysql;
using pony.Tools;
using Lambda;
using StringTools;

/**
 * Haxe MySQL Client
 * @author AxGord <axgord@gmail.com>
 */
class MySQL extends SQLBase
{	
	
	private var connection:Connection;
	/**
	 * Create MySQL object and connect
	 */
	public function new(config:Config) 
	{
		super();
		if (config.host == null) config.host = 'localhost';
		if (config.user == null) config.user = 'root';
		if (config.password == null) config.password = '';
		connection = Mysql.connect( { host:config.host, port:config.port, user:config.user, pass:config.password, database:config.database } );
		action('SET NAMES utf8', function(b:Bool) {
			if (b) action(Const.createDB + config.database, "create database", init);
		} );
		
	}
	
	private function init(r:Bool):Void if (r) connected.end();
	
	/**
	 * Make action, query with boolean result
	 */
	public function action(q:String, ?actName:String, ?p:PosInfos, _result:Bool->Void):Void {
		log(q, p);
		try {
			connection.request(q);
			_result(true);
		} catch (err:Dynamic) {
			error(actName == null ? Std.string(err) : "Can't " + actName+': ' + Std.string(err), p);
			_result(false);
		}
		
	}
	
	/**
	 * MySQL query
	 */
	inline public function query(q:String, ?p:PosInfos, cb:Dynamic->Dynamic->Array<Field>->Void):Void {
		log(q, p);
		var f = null;
		var r = null;
		var e = null;
		try {
			if (hack != null) {
				var d = connection.request('SHOW COLUMNS FROM $hack').results().array();
				f = parseFields(d);
				hack = null;
			}
			r = connection.request(q).results().array();
		} catch (err:Dynamic) {
			error(e = err, p);
		}
		cb(e, r, f);
	}
	
	private static function parseFields(a:Array<Dynamic>):Array<Field> {
		return [for (e in a) {name: e.Field, type: parseType(e.Type), length: parseLen(e.Type), flags: parseFlags(e)}];
	}
	
	inline private static function parseLen(s:String):Int return Std.parseInt(s.split('(')[1].substr(0,-1));
	inline private static function parseType(s:String):String return Types.fromString(s.split('(')[0]);
	inline private static function parseFlags(o:Dynamic<String>):Array<Flags> {
		var flags:Array<Flags> = [];
		for (f in Reflect.fields(o)) {
			switch [f, Reflect.field(o, f)] {
				case ['Key', 'PRI']: flags.push(Flags.PRI_KEY);
				case ['Extra', 'auto_increment']: flags.push(Flags.AUTO_INCREMENT);
				case ['Null', 'NO']: flags.push(Flags.NOT_NULL);
				case ['Type', v]: if (v.split(' ')[1] == 'unsigned') flags.push(Flags.UNSIGNED);
				case [_,_]:
			}
		}
		return flags;
	}
	
	
	/**
	 * Query with stream
	 */
	public function stream(q:String, ?p:PosInfos):Stream<Dynamic> {
		log(q, p);
		var s = new Stream();
		try {
			s.putIterable(connection.request(q).results());
		} catch (err:Dynamic) {
			s.errorListener(err);
		}
		return s;
	}
	
	/**
	 * Escape id (for fields, tables, databases)
	 */
	inline public function escapeId(s:String):String return '`'+connection.escape(s)+'`';
	/**
	 * Escape (for values)
	 */
	inline public function escape(s:String):String return connection.quote(s);
	
	
	/**
	 * Close connection and destroy object
	 */
	public function destroy():Void {
		connection.close();
	}
	
	
}
#end