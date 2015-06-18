/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.http.modules.mmodels;

import haxe.rtti.Meta;
import pony.db.mysql.Field;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.db.Table;
import pony.net.http.CPQ;
import pony.net.http.WebServer.EConnect;
import pony.Pair;
import pony.text.tpl.ITplPut;

using pony.Tools;
using Lambda;

enum ActResult {
	OK; ERROR(e:Map<String, String>); DBERROR;
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class Model
{
	public var lang:String;
	public var mm:MModels;
	public var name:String;
	public var columns:Map<String, pony.net.http.modules.mmodels.Field>;
	public var actions:Map<String, Action>;
	public var db:Table;
	public var cl:Class<ModelConnect>;
	
	public function new(mm:MModels, actionsClasses:Map<String, Dynamic>) {
		lang = 'en';
		name = Type.getClassName(Type.getClass(this));
		name = name.substr(name.lastIndexOf('.')+1);
		this.mm = mm;
		var n = Type.getClassName(Type.getClass(this)) + 'Connect';
		cl = cast Type.resolveClass(n);
		var ma:Dynamic<Array<{name: String, type: String}>> = untyped cl.__methoArgs__;
		actions = new Map<String, Action>();
		var fields:Dynamic = Meta.getFields(cl);
		for (f in Reflect.fields(fields)) {
			var ff:Dynamic = Reflect.field(fields, f);
			for (sf in Reflect.fields(ff))
				if (sf == 'action') {
					actions.set(f, Type.createInstance(actionsClasses.get(Reflect.field(ff, sf)[0]), [this, f, Reflect.field(ma, f)]));
				}
		}
		columns = new Map < String, pony.net.http.modules.mmodels.Field > ();
		var cs = untyped Type.getClass(this).fields;
		for (f in Reflect.fields(cs)) {
			var c:pony.net.http.modules.mmodels.Field = Reflect.field(cs, f);
			c.init(f, this);
			columns.set(f, c);
		}
		
		db = mm.db.resolve(name);
		
		init();
	}
	
	private function init():Void {
		
	}
	
	@:async
	public function prepare():Bool {
		var a:Array<Field> = [
			{name: 'id', type: Types.INT, flags: [Flags.UNSIGNED, Flags.NOT_NULL, Flags.PRI_KEY, Flags.AUTO_INCREMENT]}
		];
		for (c in columns) a.push(c.create());
		return @await db.prepare(a);
	}
	
	/*
	public function update():Void {
		db.describeAsync(function(r:Stream<DBDescribe>) {
			
			var f:Void->Void = null;
			f = function() {
				db.backup();
				f = function() { };
			};
			
			var el:List<String> = new List<String>();
			
			for (e in r)
				if (e.Field == 'id')
					el.push('id');
				else if (columns.exists(e.Field)) {
					el.push(e.Field);
				} else {
					f();
					db.dropColumn(e.Field);
				}
		
			if (el.indexOf('id') == -1) {
				f();
				db.addColumn('id', 'INT NOT NULL AUTO_INCREMENT PRIMARY KEY');
			}
			for (c in columns) {
				if (el.indexOf(c.name) == -1) {
					f();
					db.addColumn(c.name, c.create());
				}
			}
		}, err);
	}
	*/
	public static function err(e:Dynamic):Void {
		throw e;
	}
	
	public function connect(cpq:CPQ):EConnect {
		var mc:ModelConnect = Type.createInstance(cl, [this, cpq]);
		var a = new Map<String, ActionConnect>();
		for (k in actions.keys())
			switch actions[k].connect(cpq, mc) {
				case BREAK: return BREAK;
				case REG(obj): a[k] = cast obj;
				case NOTREG:
			}
		mc.actions = a;
		return REG(cast mc);
	}
	
	inline public static function dbr(r:Bool):ActResult return r ? OK : DBERROR;
	
}