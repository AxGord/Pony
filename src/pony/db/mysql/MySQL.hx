package pony.db.mysql;

import pony.db.mysql.Config;

/**
 * MySQL
 * @author AxGord <axgord@gmail.com>
 */
@:forward()
abstract MySQL(CMySQL) {

	public function new(config:Config):Void {
		this = new CMySQL(config);
	}

	@:op(a.b) public inline function resolve(s:String):Table {
		return this.resolve(s);
	}

}

class CMySQL extends
#if nodejs
pony.db.mysql.nodejs.MySQL
#else
pony.db.mysql.haxe.MySQL
#end
implements IMySQL /* implements Dynamic<Table> */ {
	
	private var tables:Map<String, Table> = new Map();
	
	/**
	 * Select table
	 */
	public function resolve(table:String):Table {
		var t:Table = tables[table];
		if (t == null) {
			t = new Table(this, escapeId(table));
			tables[table] = t;
		}
		return t;
	}
	
	/**
	 * Close connection and destroy object
	 */
	override public function destroy():Void {
		tables = null;
		connected = null;
		super.destroy();
	}
	
}