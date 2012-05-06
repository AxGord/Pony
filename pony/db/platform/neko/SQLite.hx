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
package pony.db.platform.neko;

import pony.events.Event;
import sys.db.Connection;
import sys.db.ResultSet;
import neko.db.Sqlite;

import pony.db.DBDriver;
import pony.db.DB;
import pony.fs.SimplePath;
import pony.Stream;

/**
 * ...
 * @author AxGord
 */

class SQLite implements DBDriver
{

	private var connection:Connection;
	
	public function new(conf:DBConf)
	{
		try {
			trace(SimplePath.full(conf.dbName));
			connection = Sqlite.open(conf.dbName);
		} catch (e:Dynamic) {
			connection = null;
			throw 'Connection fail';
		}
	}
	
	public function toString():String {
		return 'SQLite neko driver, ' + (connection == null ? 'not connected' : 'connected to server');
	}
	
	public function request(q:String):Stream<Dynamic> {
		var r:ResultSet = connection.request(q);
		return new Stream<Dynamic>({hasNext: r.hasNext, next: r.next});
	}
	
	public function requestAsync(q:String, ok:Stream<Dynamic>->Void, error:Dynamic->Void):Void {
		var r:ResultSet = connection.request(q);
		ok(new Stream<Dynamic>({hasNext: r.hasNext, next: r.next}));
	}
	
	public inline function quote(s:String):String {
		return connection.quote(s);
	}
	
	public inline function escape(s:String):String {
		return connection.escape(s);
	}
	
	public function ready(f:Void->Void):Void {
		f();
	}
	
	public function readyAsync(ok:Event->Void, err:Dynamic->Void):Void {
		ok(null);
	}
	
}