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
package pony.db.mysql.nodejs;

import pony.db.ISQL;
import com.dongxiguo.continuation.Continuation;
import haxe.Log;
import haxe.PosInfos;
import js.Node;
import pony.db.mysql.Config;
import pony.db.mysql.IMySQL;
import pony.db.mysql.nodejs.NodeMySQL;
import pony.events.Signal;
import pony.events.Signal0;
import pony.Logable;
import pony.magic.HasAbstract;
import pony.Stream;
using pony.Tools;

/**
 * Node.JS MySQL Client
 * haxelib: nodejs
 * npm: mysql
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':cps'))
class MySQL extends Logable<ISQL> implements HasAbstract
{
	
	static var mysqlClass:NodeMySQL = Node.require('mysql');
	
	public var onConnect:Signal0<ISQL>;
	
	public var connection:NodeMySQL_Connection;
	
	public function new(config:Config) 
	{
		super();
		onConnect = Signal.create(cast this);
		init(config, Tools.nullFunction0);
	}
	
	@:cps
	private function init(config:Config):Void {
		var db = config.database;
		var c = Reflect.copy(config);
		Reflect.deleteField(c, 'database');
		connection = mysqlClass.createConnection(c);
		var err = connection.connect().async();
		if (err != null) {
			_error('Error connecting: ' + err.stack);
			return;
		}
		var h = config.host == null ? 'localhost' : config.host;
		var p = config.port == null ? '' : ':'+config.port;
		_log('Connected to $h$p');
		
		if (prepareDatabase(db).async()) {
			_log('Database $db ready');
			onConnect.dispatch();
		}
		
	}
	
	@:cps @:abstract public function action(q:String, ?actName:String, ?p:PosInfos):Bool;
	
	inline public function query(q:String, ?p:PosInfos, cb:Dynamic->Dynamic->Array<Dynamic>->Void):Void {
		connection.query(q, cb).on('error', errorHandler);
		_log(q, p);
	}
	
	public function stream(q:String, ?p:PosInfos):Stream<Dynamic> {
		var s = new Stream();
		connection.query(q)
			.on('error', errorHandler)
			.on('error', s.errorListener)
			.on('result', s.dataListener)
			.on('end', s.endListener);
		_log(q, p);
		return s;
	}
	
	private function errorHandler(e:Dynamic):Void _error(e);
	
	inline public function escapeId(s:String):String return connection.escapeId(s);
	inline public function escape(s:String):String return connection.escape(s);
	
	
	/**
	 * Close connection and destroy object
	 */
	public function destroy():Void {
		connection.end();
	}
	
	@:cps
	private function prepareDatabase(database:String):Bool {
		if (!action(Const.createDB + database, "create database").async()) return false;
		
		var err = connection.changeUser({database: database}).async();
		if (err != null) {
			_error("Can't open database: " + err.stack);
			return false;
		}
		
		return true;
	}
	
	
}