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
package pony.db.odbc.nodejs;

#if nodejs

import pony.db.SQLBase;
import haxe.PosInfos;
import js.Node;
import pony.db.mysql.Field;
import pony.events.Waiter;
import pony.Logable;
using StringTools;
/**
 * Node.JS ODBC
 * haxelib: nodejs
 * npm: odbc
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class ODBC extends SQLBase {
	
	static private var constructor:Void->Dynamic = Node.require('odbc');
	
	private var db:Dynamic;
	
	public function new(connectionString:String) {
		super();
		db = constructor();
		db.open(connectionString, open);
	}
	
	private function open(err:Dynamic) {
		if (err != null) _error(err);
		else connected.end();
	}
	
	
	/**
	 * Make action, query with boolean result
	 */
	@:async public function action(q:String, ?actName:String, ?p:PosInfos):Bool {
		var err, _, _ = @await query(q, p);
		if (err != null) {
			_error(actName == null ? Std.string(err) : "Can't "+actName+': ' + err.stack, p);
			return false;
		} else
			return true;
	}
	
	/**
	 * MySQL query
	 */
	inline public function query(q:String, ?p:PosInfos, cb:Dynamic->Dynamic->Array<Field>->Void):Void {
		db.query(q, function(err:Dynamic, res:Dynamic, f:Array<Dynamic>) {
			if (err) _error(err);
			else cb(err, res, null);
		});
		_log(q, p);
	}
	
	/**
	 * Query with stream
	 */
	public function stream(q:String, ?p:PosInfos):Stream<Dynamic> {
		var s = new Stream();
		query(q, p, function(_, res:Array<Dynamic>, _):Void s.putIterable(res));
		return s;
	}
	
	/**
	 * Escape id (for fields, tables, databases)
	 */
	inline public function escapeId(s:String):String return s.replace('`', '');
	/**
	 * Escape (for values)
	 */
	inline public function escape(s:String):String return "'"+s.replace("'", '')+"'";
	
	/**
	 * Close connection and destroy object
	 */
	public function destroy():Void {
		db.close();
		db = null;
	}
	
}
#end