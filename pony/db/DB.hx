/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.db;

import pony.events.Event;
import pony.Ninja;
import pony.ParseBoy;
import pony.Stream;

using pony.Ultra;

/**
 * ...
 * @author AxGord
 */

typedef DBQParts = {
	driver: DBDriver,
	cols: Array<String>,
	tables: Array<String>,
	where: String,
	backupDir: String
}

typedef DBConf = {
	type: String,
	login: String,
	password: String,
	host: String,
	port: Int,
	dbName: String,
	prefix: String
}

typedef DBDescribe = {
	Key: String,
	Extra: String,
	Field: String,
	Null: String,
	Type: String
}


class DB extends Ninja<DB, DBQParts>
{
	
	private static var defaultObj:DBQParts = {
		driver: null,
		cols: null,
		tables: null,
		where: null,
		backupDir: null
	};

	public function new(?conf:String, ?oconf:DBConf)
	{
		super();
		if (conf != null || oconf != null)
			connect(conf, oconf, true);
	}
	
	
	public function connect(?conf:String, ?oconf:DBConf, usethis:Bool = false):DB {
		if (conf != null) {
			var pb:ParseBoy<String> = new ParseBoy<String>(conf);
			pb.gotoPushStr('://');
			pb.gotoPushStr('@');
			pb.gotoPushStr('/');
			pb.pushEnd();
			var lp:Array<String> = conSplit(pb.data[1]);
			var hp:Array<String> = conSplit(pb.data[2]);
			var np:Array<String> = conSplit(pb.data[3]);
			oconf = {
				type: pb.data[0],
				login: lp[0],
				password: lp[1],
				host: hp[0],
				port: Std.parseInt(hp[1]),
				dbName: np[0],
				prefix: np[1]
			};
		}
		confDefault(oconf, 'type', 'mysql');
		confDefault(oconf, 'login', 'root');
		confDefault(oconf, 'password', '');
		confDefault(oconf, 'host', '127.0.0.1');
		confDefault(oconf, 'prefix', '');
		return next({driver: switch (oconf.type) {
			case 'mysql': new MySQL(oconf);
			case 'sqlite': cast new SQLite(oconf);
			default: throw 'Unknown db type: '+oconf.type;
		}}, usethis);
	}
	
	private static function conSplit(s:String):Array<String> {
		var a:Array<String> = s == null ? [null, null] : s.split(':');
		if (a[0] == '') a[0] = null;
		if (a.length == 1)
			a.push(null);
		return a;
	}
	
	public static function confDefault(o:DBConf, f:String, v:Dynamic):Void {
		if (Reflect.field(o, f) == null) {
			Reflect.setField(o, f, v);
		}
	}
	
	public inline function toString():String {
		return Std.string(obj);
	}
	
	public inline function request(q:String):Stream<Dynamic> {
		trace(q);
		return obj.driver.request(q);
	}
	
	public inline function requestAsync(q:String, ok:Stream<Dynamic>->Void, error:Dynamic->Void) {
		trace(q);
		obj.driver.requestAsync(q, ok, error);
	}
	
	public inline function escape(s:String):String {
		return obj.driver.escape(s);
	}
	
	public inline function quote(s:String):String {
		return obj.driver.quote(s);
	}
	
	public function tables():Stream<String> {
		return new Stream<String>(
			request('SHOW TABLES'),
			function(o:Dynamic<String>):String {
				return Reflect.field(o, Reflect.fields(o)[0]);
			}
		);
	}
	
	public function tablesAsync(ok:Stream<String>->Void, ?error:Dynamic->Void):Void {
		requestAsync('SHOW TABLES', function(r:Stream<Dynamic>) {
			ok(new Stream<String>(r,
				function(o:Dynamic<String>):String {
					return Reflect.field(o, Reflect.fields(o)[0]);
				}
			));
		}, error);
	}
	
	public function describe():Stream<DBDescribe> {
		return cast request('DESCRIBE ' + obj.tables.join(', '));
	}
	
	public function describeAsync(ok:Stream<DBDescribe>->Void, error:Dynamic->Void):Void {
		requestAsync('DESCRIBE ' + obj.tables.join(', '), cast ok, error);
	}
	
	public function select(?col:String, ?cols:Array<String>, ?colso:Dynamic, usethis:Bool = false):DB {
		if (colso != null) {
			cols = [];
			for (c in Reflect.fields(colso))
				cols.push(Reflect.field(colso, c)+' AS '+c);
		}
		return if (col != null)
			next( { cols: [col] }, usethis );
		else if (cols != null)
			next( { cols: cols }, usethis );
		else
			next({cols: null}, usethis );
	}
	
	public function table(?table:String, ?tables:Array<String>, usethis:Bool = false):DB {
		return next( { tables:
			if (table != null) [table.toLowerCase()]
			else if (tables != null) tables.map(function(s:String)return s.toLowerCase())
			else null
		}, usethis);
	}
	
	public function where(s:String, usethis:Bool = false):DB {
		return next( { where: s }, usethis);
	}
	
	public function create(cols:Dynamic<String>):Void {
		var a:Array<String> = [];
		for (c in Reflect.fields(cols))
			a.push(c+' '+Reflect.field(cols, c));
		for (t in obj.tables)
			request('CREATE TABLE '+t+'('+a.join(', ')+')');
	}
	
	public function result():Stream<Dynamic> {
		if (obj.tables == null) throw 'Not set table';
		return request('SELECT '+(obj.cols == null ? '*' : obj.cols.map(escape).join(', ')) + ' FROM ' + obj.tables.map(escape).join(', '));
	}
	
	public function resultAsync(ok:Stream<Dynamic>->Void, error:Dynamic->Void):Void {
		if (obj.tables == null) throw 'Not set table';
		requestAsync('SELECT '+(obj.cols == null ? '*' : obj.cols.map(escape).join(', ')) + ' FROM ' + obj.tables.map(escape).join(', '), ok, error);
	}
	
	private function tildator(s:String):String return '`'+escape(s)+'`'
	
	public inline function ready(f:Void->Void):Void {
		obj.driver.ready(f);
	}
	
	public inline function readyAsync(ok:Event->Void, err:Dynamic->Void):Void {
		obj.driver.readyAsync(ok, err);
	}
	
	public function insert(o:Dynamic):Void {
		var fields:Array<String> = Reflect.fields(o);
		var values:Array<String> = [];
		for (f in fields) {
			var v:Dynamic = Reflect.field(o, f);
			if (v == null)
				values.push('NULL');
			else
				values.push(quote(v));
		}
		request('INSERT INTO ' + obj.tables.join(', ') + ' (' +
			fields.map(function(s:String) return '`' + s + '`').join(', ') +
			' ) VALUES ( ' + values.join(', ') + ' )');
	}
	
	public function insertAsync(o:Dynamic, ok:Dynamic->Void, ?error:Dynamic->Void):Void {
		var fields:Array<String> = Reflect.fields(o);
		var values:Array<String> = [];
		for (f in fields) {
			var v:Dynamic = Reflect.field(o, f);
			if (v == null)
				values.push('NULL');
			else
				values.push(quote(v));
		}
		requestAsync('INSERT INTO ' + obj.tables.join(', ') + ' (' +
			fields.map(function(s:String) return '`' + s + '`').join(', ') +
			' ) VALUES ( ' + values.join(', ') + ' )',
			ok, error);
	}
	
	public function drop():Void {
		request('DROP TABLE ' + obj.tables.join(', '));
	}
	
	public function dropAsync(ok:Dynamic->Void, error:Dynamic->Void):Void {
		requestAsync('DROP TABLE ' + obj.tables.join(', '), ok, error);
	}
	
	public function dropColumn(c:String):Void {
		request('ALTER TABLE '+obj.tables.join(', ')+' DROP ' +c);
	}
	
	public function addColumn(c:String, t:String):Void {
		request('ALTER TABLE '+obj.tables.join(', ')+' ADD '+c+' '+t);
	}
	
	public function backupDir(d:String, useThis:Bool = false):DB {
		return next( { backupDir: d }, useThis);
	}
	
	public function backup():Void {
		request('BACKUP TABLE '+obj.tables.map(tildator).join(', ')+" TO '"+obj.backupDir+"'");
	}
	
	public function restore():Void {
		request('RESTORE TABLE '+obj.tables.map(tildator).join(', ')+" FROM '"+obj.backupDir+"'");
	}
	
}