package pony.db.odbc.nodejs;

#if nodejs

import pony.db.SQLBase;
import haxe.PosInfos;
import js.Node;
import pony.db.mysql.Field;
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
		else connected.ready();
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