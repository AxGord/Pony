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
package pony.db.mysql;

using pony.Tools;

/**
 * TablePrepare
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':cps'))
class TablePrepare {
	
	private var mysql:MySQL;
	private var table:String;
	
	public function new(mysql:MySQL, table:String) 
	{
		this.mysql = mysql;
		this.table = table;
	}
	
	@:cps
	public function prepare(fields:Array<Field>):Bool {
		mysql._log('prepare table '+table);
		var err, _, rem = mysql.query('SELECT * FROM $table LIMIT 0').async();
		if (err != null) {//Create table
			var cr:Array<String> = [];
			for (f in fields) {
				var name = mysql.escapeId(f.name);
				cr.push(name+' '+f.type.toString()+decorateLength(f.length)+' '+Flags.array2string(f.flags));
			}
			if (!mysql.action('CREATE TABLE $table ('+ cr.join(', ') +')', 'create table').async()) return false;
		} else {//Update table
			var remote:Array<Field> = parseFields(rem);
			var map:Map<String,Int> = makeFieldsMap(fields);
			
			{//Rename
				var remMap:Map<String,Int> = makeFieldsMap(remote);
				var free:Array<Field> = remote.copy();
				for (f in fields) if (remMap.exists(f.name)) free = free.delete(remMap[f.name]);
				free = renameTableFields(fields, remote, remMap, free, chk1).async();
				if (free == null) return false;
				free = renameTableFields(fields, remote, remMap, free, chk2).async();
				if (free == null) return false;
				free = renameTableFields(fields, remote, remMap, free, chk3).async();
				if (free == null) return false;
				free = renameTableFields(fields, remote, remMap, free, chk4).async();
				if (free == null) return false;
				free = renameTableFields(fields, remote, remMap, free, chk5).async();
				if (free == null) return false;
			}
			
			var again:Bool = true;
			//Drop
			while (again) {
				again = false;
				for (f in remote.kv()) if (!map.exists(f.value.name)) {
					var name = mysql.escapeId(f.value.name);
					if (!mysql.action('ALTER TABLE $table DROP $name', 'drop table field').async()) return false;
					remote = remote.delete(f.key);
					again = true;
					break;
				}
			}
			again = true;
			//Move
			while (again) {
				again = false;
				for (f in remote.kv()) {
					if (map[f.value.name] != f.key) {
						var i = map[f.value.name];
						var postfix = i == 0 ? ' FIRST' : ' AFTER ' + mysql.escapeId(fields[i - 1].name);
						if (!mysql.action(alter(fields[i], f.value)+postfix, 'move table field').async()) return false;
						remote = remote.swap(i, f.key);
						remote[i] = fields[i];
						again = true;
						break;
					}
				}
			}
			//Update
			for (_ in 0...fields.length) {
				var f = fields.shift();
				var r = remote.shift();
				var ef:Bool = false;
				for (fl in f.flags) if (!r.flags.exists(fl)) ef = true;
				if (ef || f.type != r.type || (f.length != null && f.length != r.length)) {
					if (!mysql.action(alter(f, r), 'update table field').async()) return false;
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
	
	@:cps
	private function renameTableFields(fields:Array<Field>, remote:Array<Field>, remMap:Map<String,Int>, free:Array<Field>, chk:Field->Field->Bool):Array<Field> {
		for (f in fields) if (!remMap.exists(f.name)) for (r in free)
			if (chk(f, r)) {
				if (!mysql.action(alter(f, r), 'rename table field').async()) return null;
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
	
	inline static function decorateLength(len:Null<Int>):String return len != null ? '($len)' : '';
	
	static function makeFieldsMap(fields:Array<Field>):Map<String,Int>
		return [for (f in fields.kv()) f.value.name => f.key];
	
	static function parseFields(a:Array<Dynamic>):Array<Field> {
		return [for (e in a) {name: e.orgName, type: e.type, length: calcLen(e.type, e.length), flags: parseFlags(e.flags)}];
	}
	
	static function calcLen(type:Types, length:Int):Int {
		return switch type {
			case Types.CHAR: Std.int(length / 3);
			case _: length;
		}
	}
	
	static function parseFlags(f:Int):Array<Flags> {
		var r = [];
		for (k in Flags.toStr.keys()) if (f & k != 0) r.push(k);
		return r;
	}
}