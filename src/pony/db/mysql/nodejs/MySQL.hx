package pony.db.mysql.nodejs;

#if nodejs
import haxe.PosInfos;
import js.Node;
import pony.db.ISQL;
import pony.db.mysql.Config;
import pony.db.mysql.nodejs.NodeMySQL;
import pony.db.SQLBase;
import pony.events.WaitReady;
import pony.Logable;
import pony.Stream;

using pony.Tools;

/**
 * Node.JS MySQL Client
 * haxelib: nodejs
 * npm: mysql
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class MySQL extends SQLBase {

	private static var mysqlClass: NodeMySQL = Node.require('mysql');

	private var connection: NodeMySQL_Connection;

	/**
	 * Create MySQL object and connect
	 */
	public function new(config: Config) {
		super();
		connected = new WaitReady();
		init(config, Tools.nullFunction0);
	}

	/**
	 * MySQL query
	 */
	public inline function query(q: String, ?p: PosInfos, cb: Dynamic -> Dynamic -> Array<Field> -> Void): Void {
		connection.query(q, function(err: Dynamic, res: Dynamic, f: Array<Dynamic>) {
			if (err) error(err);
			final fields: Array<Field> = f == null ? null : parseFields(f);
			cb(err, res, fields);
		});
		log(q, p);
	}

	/**
	 * Escape id (for fields, tables, databases)
	 */
	public inline function escapeId(s: String): String return connection.escapeId(s);

	/**
	 * Escape (for values)
	 */
	public inline function escape(s: String): String return connection.escape(s);

	/**
	 * Make action, query with boolean result
	 */
	@:async public function action(q: String, ?actName: String, ?p: PosInfos): Bool {
		var err;
		var _;
		final _ = @await query(q, p);
		if (err == null) return true;
		error(actName == null ? '$err' : "Can't " + actName + ': ' + err.stack, p);
		return false;
	}

	/**
	 * Query with stream
	 */
	public function stream(q: String, ?p: PosInfos): Stream<Dynamic> {
		final s = new Stream();
		connection.query(q).on('error', errorHandler).on('error', s.errorListener).on('result', s.dataListener).on('end', s.endListener);
		log(q, p);
		return s;
	}

	/**
	 * Close connection and destroy object
	 */
	override public function destroy(): Void {
		super.destroy();
		connection.end();
		connection = null;
	}

	@:async private function init(config: Config): Void {
		final db = config.database;
		final c = Reflect.copy(config);
		Reflect.deleteField(c, 'database');
		connection = mysqlClass.createConnection(c);
		final err: pony.db.mysql.nodejs.NodeMySQL.NodeMySQL_Connection = @await connection.connect();
		if (err != null) {
			error('Error connecting: ' + err.stack);
			return;
		}
		final h = config.host == null ? 'localhost' : config.host;
		final p = config.port == null ? '' : ':${config.port}';
		log('Connected to $h$p');

		if (!@await prepareDatabase(db)) return;
		log('Database $db ready');
		connected.ready();

	}

	private function errorHandler(e: Dynamic): Void error(e);

	@:async private function prepareDatabase(database: String): Bool {
		if (!@await action(Const.createDB + database + Const.createDBPostfix, 'create database')) return false;

		final err = @await connection.changeUser({ database: database });
		if (err == null) return true;
		error("Can't open database: " + err.stack);
		return false;
	}

	private static function parseFields(a: Array<Dynamic>): Array<Field> {
		return [for (e in a)
			{ name: e.orgName, type: e.type, length: calcLen(e.type, e.length), flags: parseFlags(e.flags) }
		];
	}

	private static function calcLen(type: Types, length: Int): Int {
		return switch type {
			case Types.CHAR: Std.int(length / 3);
			case _: length;
		}
	}

	private static function parseFlags(f: Int): Array<Flags> {
		return [for (k in Flags.toStr.keys()) if (f & k != 0) k];
	}

}
#end
