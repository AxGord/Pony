package db;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

#if neko
import pony.db.DB;
#end

import pony.magic.Declarator;

/**
 * ...
 * @author AxGord
 */

class DBTest
{

	@BeforeClass
	public function beforeClass():Void
	{
	}
	
	@Test
	public function test():Void {
		/*
		var db:DB = new DB();
		db.connect('haxetestdb', true);
		//db.connect('sqlite://haxetestdb.db', true);
		trace(db.request('SELECT * FROM `' + db.escape('gfg') + '` LIMIT 0 , 30'));
		trace(db.select(['CURRENT_DATE', '`wew`']).table('gfg').result());
		trace(db.request('SELECT CURRENT_DATE'));
		trace(db.tables());
		for (f in db.table('pet').describe())
			trace(f.Field);*/
		/*
		db.table('pet').create({
			name: 'VARCHAR(20)',
			owner: 'VARCHAR(20)',
			species: 'VARCHAR(20)',
			sex: 'CHAR(1)',
			birth: 'DATE',
			death: 'DATE'
		});
		*/
		/*
		SQL.where(db, {
			id == 3 && password == pass
		}, true);*/
		// ==> db.where("id = 3 AND password = "+db.quote(pass), true)
		//db.where(DB.and(DB.cond('id', 3)));
		//trace(db.select('ef'));
	}
	
}

//class Users {
	/*
	private static var columns:Array<Column> = [
		new CId('id'),
		new CString('login', 3...18)
	];
	*/
	/*
	private var db:DB;
	
	public function many():Dynamic {
		return db.select(['id', 'login', 'reg_date', 'last_visit']);
	}
	
	public function single():Dynamic {
		return db.select(['id', 'login', 'reg_date', 'last_visit']);
	}
	
	
}*/