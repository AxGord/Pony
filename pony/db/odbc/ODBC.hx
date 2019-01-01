package pony.db.odbc;

#if nodejs
import pony.db.ISQL;
import pony.db.Table;

/**
 * ODBC
 * @author AxGord <axgord@gmail.com>
 */
class ODBC extends
#if nodejs
pony.db.odbc.nodejs.ODBC
#end
implements ISQL implements Dynamic<Table> {
	
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
#end