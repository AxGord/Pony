package pony.db ;

import pony.magic.Declarator;
import pony.magic.Ninja;

#if macro
import haxe.macro.Expr;
#else
import haxe.PosInfos;
import pony.db.ISQL;
import pony.db.mysql.Field;
import pony.db.mysql.TablePrepare;
import pony.Stream;

using pony.Tools;
#end

/**
 * WhereElement
 * Helper for where function
 */
enum WhereElement {
	Text(s:String);
	Value(s:Dynamic);
	Id(s:Dynamic);
}

/**
 * WhereData
 * Helper for where function
 */
typedef WhereData = Array<WhereElement>;

@:forward()
abstract Table(CTable) {

	public function new(mysql:ISQL, table:String):Void {
		this = new CTable(mysql, table);
	}

	@:op(a.b) public inline function resolve(s:String):Table {
		return this.resolve(s);
	}

}

/**
 * MySQL table, powerful instrument for work with database tables
 * @author AxGord <axgord@gmail.com>
 */
class CTable /* implements Dynamic < Table > */ implements Declarator implements Ninja
{
	#if !macro
	@:arg private var mysql:ISQL;
	@:arg private var table:String;
	private var _select:Array<String> = [];
	private var solo:Bool = false;
	private var order:String = '';
	private var _limit:Null<Int>;
	private var _begin:Int = 0;
	private var _where:String = '';
	private var _error:String->Void = Tools.nullFunction1;
	
	inline private function ninjaCreate():Table return new Table(mysql, table);
	/**
	 * Error hander
	 */
	@:n inline public function error(f:String->Void):Table _error = f;
	/**
	 * Select fields for query
	 */
	@:n inline public function selectArray(a:Array<String>):Table _select = a;
	/**
	 * Order asc for field
	 */
	@:n inline public function asc(field:String):Table order = ' ORDER BY '+mysql.escapeId(field)+' ASC';
	/**
	 * Order desc for field
	 */
	@:n inline public function desc(field:String):Table order = ' ORDER BY '+mysql.escapeId(field)+' DESC';
	/**
	 * Data for query 'where', helper for where function
	 */
	@:n public function whereData(data:WhereData):Table {
		var w = ' WHERE ';
		for (e in data) switch e {
			case WhereElement.Text(s): w += s;
			case WhereElement.Value(s): w += mysql.escape(s);
			case WhereElement.Id(s): w += mysql.escapeId(s);
		}
		_where = w;
	}
	/**
	 * Query limit
	 */
	@:n inline public function limit(n:Int):Table _limit = n;
	/**
	 * Starting element for query return
	 */
	@:n inline public function begin(n:Int):Table _begin = n;
	/**
	 * Set page number, use limit for set elements count per page
	 */
	inline public function page(n:Int):Table return begin(_limit * n);
	/**
	 * Select single field for query
	 */
	@:n inline public function resolve(s:String):Table {
		_select = [s];
		solo = true;
	}
	/**
	 * Get stream for current query
	 */
	public function stream(?p:PosInfos):Stream<Dynamic> {
		var s = mysql.stream(genGetQuery(), p);
		return solo ? s.map(soloMap) : s;
	}
	
	private function soloMap(d:Dynamic):Dynamic return Reflect.field(d, _select[0]);
	/**
	 * Get result for current query
	 */
	public function get(cb:Array<Dynamic>->Void, ?p:PosInfos):Void {
		mysql.query(genGetQuery(), p, function(err:Dynamic, fields:Dynamic, _):Void {
			if (err != null) {
				_error(err);
				mysql.error(err);
			} else {
				cb(solo ? fields.map(soloMap): fields);
			}
		});
	}
	/**
	 * Get first for current query
	 */
	public function first(cb:Dynamic->Void, ?p:PosInfos):Void {
		limit(1).get(function(r:Array<Dynamic>) cb(r[0]));
	}
	
	inline private function genGetQuery():String
		return 'SELECT ' + (_select.length == 0 ? '*' : _select.map(mysql.escapeId).join(', '))
		+ ' FROM $table' + _where + order + (_limit == null ? '' : ' LIMIT $_begin, $_limit');
	
	/**
	 * Prepare this table
	 * @param fields - table configuration
	 */
	inline public function prepare(fields:Array<Field>, cb:Bool->Void):Void new TablePrepare(mysql, table).prepare(fields, cb);
	
	/**
	 * Clear this table
	 */
	inline public function clear(cb:Bool->Void, ?p:PosInfos):Void mysql.action('TRUNCATE TABLE $table', 'clear table', p, cb);
	
	/**
	 * Insert data to table
	 */
	public function insert(data:Map<String, DBV>, cb:Bool->Void, ?p:PosInfos):Void {
		var keys = [for (f in data.keys()) mysql.escapeId(f)];
		var values = [for (d in data) d.get(mysql.escape)];
		mysql.action('INSERT INTO $table (' + keys.join(', ') + ') VALUES (' + values.join(', ') + ')', 'insert', p, cb);
	}
	
	/**
	 * Update data it table
	 */
	public function update(data:Map<String, DBV>, cb:Bool->Void, ?p:PosInfos):Void {
		var set = [for (f in data.keys()) mysql.escapeId(f) + '=' + data[f].get(mysql.escape)];
		mysql.action('UPDATE $table SET ' + set.join(', ') + _where, cb);
	}
	 
	/**
	 * Delete selected rows from table
	 */
	public function delete(cb:Bool->Void, ?p:PosInfos):Void {
		var q = 'DELETE FROM $table' + _where + order + (_limit == null ? '' : ' LIMIT $_begin, $_limit');
		mysql.query(q, p, function(err:Dynamic, fields:Dynamic, _):Void {
			if (err != null) {
				_error(err);
				mysql.error(err);
			} else {
				cb(solo ? fields.map(soloMap): fields);
			}
		});
	}
	 
	#end
	
	/**
	 * Select fields
	 */
	macro public function select(args:Array<Expr>):Expr {
		if (args.length < 2) throw 'need arguments';
		var th:Expr = args.shift();
		return macro $th.selectArray([$a{args}]);
	}
	
	/**
	 * Query where (use haxe for that)
	 */
	macro public function where(args:Array<Expr>):Expr {
		if (args.length != 2) throw 'need one argument';
		var e:Expr = args.pop();
		var th:Expr = args.pop();
		var a = TableMacro.transExpr(e, []);
		var ex = { expr:EArrayDecl(a), pos:th.pos };
		return macro $th.whereData($ex);
	}
	
	
}