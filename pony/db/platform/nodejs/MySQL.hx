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
package pony.db.platform.nodejs;

import haxe.Timer;
import pony.db.DBDriver;
import pony.db.DB;
import js.Node;
import pony.events.Event;
import pony.events.Waiter;

class MySQL implements DBDriver
{
	private static var mysql:Dynamic = Node.require('mysql');
	
	private var conf:DBConf;
	private var connection:Dynamic;
	private var waiter:Waiter;
	private var pingTimer:Timer;
	
	public function new(conf:DBConf)
	{
		
		DB.confDefault(conf, 'port', 3306);
		this.conf = conf;
		waiter = new Waiter();
		connect();
	}
	
	private function connect():Void {
		if (conf.dbName == null)
			connection = mysql.createClient( {
				user: conf.login,
				password: conf.password
			});
		else
			connection = mysql.createClient( {
				user: conf.login,
				password: conf.password,
				database: conf.dbName
			});
		connection.ping(contest);
		waiter.wait(startPing);
		Node.process.nextTick(nt);
	}
	
	private function nt():Void {
		waiter.wait(waiter.destroy);
	}
	
	private function startPing():Void {
		trace('Connected');
		pingTimer = new Timer(5000);
		pingTimer.run = ping;
	}
	
	private function contest(e:Dynamic):Void {
		if (e != null)
			error(e);
		else
			waiter.dispatch();
	}
	
	private function error(e:Dynamic):Void {
		trace('Error, reconnect after 5 sec...');
		connection.destroy();
		connection = null;
		Timer.delay(connect, 5000);
	}
	
	private function ping():Void {
		try {
			connection.ping(lostest);
		} catch (e:Dynamic) {
			lostest(1);
		}
	}
	
	private function lostest(e:Dynamic):Void {
		if (e != null) {
			trace('Lost connection, reconnect...');
			pingTimer.stop();
			pingTimer = null;
			try {
				connection.destroy();
			} catch (err:Dynamic) {}
			connection = null;
			connect();
		}
	}
	
	public function toString():String {
		return 'MySQL nodejs driver, ' + (connection == null ? 'not connected' : 'connected to server');
	}
	
	public function request(q:String):Stream<Dynamic> {
		connection.query(q);
		//trace('Warning: i\'m not return result');
		return null;
	}
	
	public function requestAsync(q:String, ok:Stream<Dynamic>->Void, error:Dynamic->Void):Void {
		connection.query(q, function(err, results, fields) {
			if (err) {
			  error(err);
			  return;
			}
			//trace(results);
			//trace(fields);
			ok(new Stream<Dynamic>(results));
		});
	}
	
	public inline function quote(s:String):String {
		return connection.escape(s);
	}
	
	public inline function escape(s:String):String {
		s = connection.escape(s);
		if (s.charAt(0) == "'")
			s = s.substr(1, s.length - 2);
		return s;
	}
	
	public inline function ready(f:Void->Void):Void {
		waiter.wait(f);
	}
	
	public inline function readyAsync(ok:Event->Void, err:Dynamic->Void):Void {
		waiter.waitAsync(ok, err);
	}
	
}