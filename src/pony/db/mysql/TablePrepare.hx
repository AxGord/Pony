package pony.db.mysql;

import pony.db.ISQL;

using pony.Tools;

/**
 * TablePrepare
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class TablePrepare {
	
	private var mysql:ISQL;
	private var table:String;
	
	inline public function new(mysql:ISQL, table:String) 
	{
		this.mysql = mysql;
		this.table = table;
	}
	
	@:async public function prepare(fields:Array<Field>):Bool {
		mysql.log('prepare table ' + table);
		mysql.hack = table;
		var err, _, remote = @await mysql.query('SELECT * FROM $table LIMIT 0');
		if (err != null) {//Create table
			var cr:Array<String> = [];
			for (f in fields) {
				var name = mysql.escapeId(f.name);
				cr.push(name + ' ' + f.type.toString() + decorateLength(f.length) + ' ' + Flags.array2string(f.flags));
			}
			if (!@await mysql.action('CREATE TABLE $table ('+ cr.join(', ') +')', 'create table')) return false;
		} else {//Update table
			var map:Map<String,Int> = makeFieldsMap(fields);
			{//Rename
				mysql.log('Search fields for rename');
				var remMap:Map<String,Int> = makeFieldsMap(remote);
				var free:Array<Field> = remote.copy();
				for (f in fields) if (remMap.exists(f.name)) free = free.delete(remMap[f.name]);
				free = @await renameTableFields(fields, remote, remMap, free, chk1);
				if (free == null) return false;
				/*
				free = @await renameTableFields(fields, remote, remMap, free, chk2);
				if (free == null) return false;
				free = @await renameTableFields(fields, remote, remMap, free, chk3);
				if (free == null) return false;
				free = @await renameTableFields(fields, remote, remMap, free, chk4);
				if (free == null) return false;
				free = @await renameTableFields(fields, remote, remMap, free, chk5);
				if (free == null) return false;
				*/
			}
			
			var again:Bool = true;
			//Drop
			mysql.log('Search fields for drop');
			while (again) {
				again = false;
				for (f in remote.kv()) if (!map.exists(f.value.name)) {
					var name = mysql.escapeId(f.value.name);
					if (!@await mysql.action('ALTER TABLE $table DROP $name', 'drop table field')) return false;
					remote = remote.delete(f.key);
					again = true;
					break;
				}
			}
			again = true;
			
			//Add
			if (fields.length > remote.length) {
				mysql.log('Search fields for add');
				for (f in fields) if (!remMap.exists(f.name)) {
					if (!@await mysql.action(alterAdd(f), 'add table field')) return false;
					remote.push(f);
				}
			}
			
			mysql.log('Search fields for move');
			//Move
			while (again) {
				again = false;
				for (f in remote.kv()) {
					if (map[f.value.name] != f.key) {
						var i = map[f.value.name];
						var postfix = i == 0 ? ' FIRST' : ' AFTER ' + mysql.escapeId(fields[i - 1].name);
						if (!@await mysql.action(alter(fields[i], f.value)+postfix, 'move table field')) return false;
						remote = remote.swap(i, f.key);
						remote[i] = fields[i];
						again = true;
						break;
					}
				}
			}
			//Update
			mysql.log('Search fields for update');
			for (_ in 0...fields.length) {
				var f = fields.shift();
				var r = remote.shift();
				if (r == null) return false;
				var ef:Bool = false;
				for (fl in f.flags) if (!r.flags.exists(fl)) ef = true;
				if (ef || f.type != r.type || (f.length != null && f.type != Types.TEXT && f.length != r.length)) {
					if (!@await mysql.action(alter(f, r), 'update table field')) return false;
				}
			}
		}
		return true;
	}
	
	static private function chk1(f:Field, r:Field):Bool return f.type == r.type && f.flags.equal(r.flags) && f.length == r.length;
	static private function chk2(f:Field, r:Field):Bool return f.type == r.type && f.flags.equal(r.flags);
	static private function chk3(f:Field, r:Field):Bool return f.type == r.type && f.length == r.length;
	static private function chk4(f:Field, r:Field):Bool return f.type == r.type || f.flags.equal(r.flags);
	static private function chk5(f:Field, r:Field):Bool return f.length == r.length;
	
	@:async private function renameTableFields(fields:Array<Field>, remote:Array<Field>, remMap:Map<String,Int>, free:Array<Field>, chk:Field->Field->Bool):Array<Field> {
		for (f in fields) if (!remMap.exists(f.name)) for (r in free)
			if (chk(f, r)) {
				if (!@await mysql.action(alter(f, r), 'rename table field')) return null;
				free.remove(r);
				var i = remote.indexOf(r);
				remMap.remove(r.name);
				remMap[f.name] = i;
				remote[i].copyFields(f);
			}
		return free;
	}
	
	public function alter(f:Field, r:Field):String {
		var name = mysql.escapeId(f.name);
		var name2 = mysql.escapeId(r.name);
		var flags = f.flags.copy();
		var i = flags.indexOf(PRI_KEY);
		if (r.flags.indexOf(PRI_KEY) != -1 && i != -1) flags = flags.delete(i);//Don't add primary key if him exists
		return 'ALTER TABLE $table CHANGE $name2 $name ' + f.type.toString() + decorateLength(f.length) + ' ' + Flags.array2string(flags);
	}
	
	public function alterAdd(f:Field):String {
		var name = mysql.escapeId(f.name);
		var flags = f.flags.copy();
		return 'ALTER TABLE $table ADD $name ' + f.type.toString() + decorateLength(f.length) + ' ' + Flags.array2string(flags);
	}
	
	inline private static function decorateLength(len:Null<Int>):String return len != null ? '($len)' : '';
	
	private static function makeFieldsMap(fields:Array<Field>):Map<String,Int>
		return [for (f in fields.kv()) f.value.name => f.key];
	
}
#end