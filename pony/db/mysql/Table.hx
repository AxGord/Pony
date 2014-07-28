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

#if macro
import haxe.macro.Expr;
#end
import haxe.PosInfos;
import pony.magic.Declarator;
import pony.magic.Ninja;
import pony.Stream;

using pony.Tools;

enum WhereElement {
	Text(s:String);
	Value(s:Dynamic);
	Id(s:Dynamic);
}

typedef WhereData = Array<WhereElement>;

/**
 * MySQL table
 * @author AxGord <axgord@gmail.com>
 */
class Table implements Dynamic < Table > implements Declarator implements Ninja
{
	#if !macro
	@:arg private var mysql:MySQL;
	@:arg private var table:String;
	private var _select:Array<String> = [];
	private var solo:Bool = false;
	private var order:String = '';
	private var _limit:Null<Int>;
	private var _begin:Int = 0;
	private var _where:String = '';
	
	inline private function ninjaCreate():Table return new Table(mysql, table);
	
	@:n inline public function selectArray(a:Array<String>):Table _select = a;
	
	@:n inline public function asc(field:String):Table order = ' ORDER BY '+mysql.escapeId(field)+' ASC';
	
	@:n inline public function desc(field:String):Table order = ' ORDER BY '+mysql.escapeId(field)+' DESC';
	
	@:n public function whereData(data:WhereData):Table {
		var w = ' WHERE ';
		for (e in data) switch e {
			case WhereElement.Text(s): w += s;
			case WhereElement.Value(s): w += mysql.escape(s);
			case WhereElement.Id(s): w += mysql.escapeId(s);
		}
		_where = w;
	}
	
	@:n inline public function limit(n:Int):Table _limit = n;
	
	@:n inline public function begin(n:Int):Table _begin = n;
	
	inline public function page(n:Int):Table return begin(_limit * n);
	
	inline public function resolve(s:String):Table {
		var t = selectArray([s]);
		t.solo = true;
		return t;
	}
	
	public function stream(?p:PosInfos):Stream<Dynamic> {
		var s = mysql.stream(genGetQuery(), p);
		return solo ? s.map(soloMap) : s;
	}
	
	private function soloMap(d:Dynamic):Dynamic return Reflect.field(d, _select[0]);
	
	public function get(?p:PosInfos, cb:?Array<Dynamic>->Void):Void {
		mysql.query(genGetQuery(), p, function(err:Dynamic, fields:Dynamic, _):Void {
			if (err != null) {
				mysql._error(err);
				cb();
			} else {
				cb(solo ? fields.map(soloMap): fields);
			}
		});
	}
	
	inline private function genGetQuery():String
		return 'SELECT ' + (_select.length == 0 ? '*' : _select.map(mysql.escapeId).join(', '))
		+ ' FROM $table' + _where + order + (_limit == null ? '' : ' LIMIT $_begin, $_limit');
	
	public function prepare(fields:Array<Field>, cb:Bool->Void):Void {
		var h = new TablePrepare(mysql, table);
		h.prepare(fields, cb);
	}
	#end
	
	macro public function select(args:Array<Expr>):Expr {
		if (args.length < 2) throw 'need arguments';
		var th:Expr = args.shift();
		return macro $th.selectArray([$a{args}]);
	}
	
	macro public function where(args:Array<Expr>):Expr {
		if (args.length != 2) throw 'need one argument';
		var e:Expr = args.pop();
		var th:Expr = args.pop();
		var a = TableMacro.transExpr(e, []);
		var ex = { expr:EArrayDecl(a), pos:th.pos };
		return macro $th.whereData($ex);
	}
	
	
}