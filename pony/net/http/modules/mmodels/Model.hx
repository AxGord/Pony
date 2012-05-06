/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

enum ActResult {
	OK; ERROR(e:Hash<String>); DBERROR();
}

import haxe.rtti.Meta;
import pony.db.DB;
//import pony.magic.Declarator;
import pony.tpl.ITplPut;
import pony.net.http.WebServer;
import pony.Stream;

using pony.Ultra;
using Lambda;

#if !macro
@:autoBuild(pony.net.http.modules.mmodels.Builder.build())
#end
class Model
{
	public var lang:String;
	public var mm:MModels;
	public var name:String;
	public var columns:Hash<Column>;
	public var actions:Hash<Action>;
	public var db:DB;
	
	public function new(mm:MModels, actionsClasses:Hash<Dynamic>) {
		lang = 'en';
		name = Type.getClassName(Type.getClass(this));
		name = name.substr(name.lastIndexOf('.')+1);
		this.mm = mm;
		var ma:Dynamic<Array<{name: String, type: String}>> = untyped Type.getClass(this).__methoArgs__;
		actions = new Hash<Action>();
		var fields:Dynamic = Meta.getFields(Type.getClass(this));
		for (f in Reflect.fields(fields)) {
			var ff:Dynamic = Reflect.field(fields, f);
			for (sf in Reflect.fields(ff))
				if (sf == 'action') {
					actions.set(f, Type.createInstance(actionsClasses.get(Reflect.field(ff, sf)), [this, f, Reflect.field(ma, f)]));
				}
		}
		
		columns = new Hash < Column > ();
		var cs = untyped Type.getClass(this).cols;
		for (f in Reflect.fields(cs)) {
			var c:Column = Reflect.field(cs, f);
			c.init(f, this);
			columns.set(f, c);
		}
		
		db = mm.db.table(name);
		
		init();
	}
	
	private function init():Void {
		
	}
	
	public function create():Void {
		var o:Dynamic<String> = {
			id: 'INT NOT NULL AUTO_INCREMENT PRIMARY KEY'
		};
		for (c in columns)
			Reflect.setField(o, c.name, c.create());
		db.create(o);
	}
	
	public function update():Void {
		db.describeAsync(function(r:Stream<DBDescribe>) {
			/*if (r.length() != columns.len() + 1) {
				db.resultAsync(function(r:Stream<Dynamic>):Void {
					db.dropAsync(function(Void) {
						create();
						for (e in r)
							db.insert(e);
					}, err);
				}, err);
			}*/
			
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
	
	public static function err(e:Dynamic):Void {
		throw e;
	}
	
	public function tpl(d:CPQ, parent:ITplPut):ITplPut {
		return new ModelPut(this, d, parent);
	}
	
	public function connect(cpq:CPQ):Bool {
		for (a in actions)
			if (a.connect(cpq)) return true;
		return false;
	}
	
	public function action(cpq:CPQ, h:Hash<Hash<String>>):Bool {
		for (k in h.keys())
			if (actions.get(k).action(cpq, h.get(k))) return true;
		return false;
	}
	
}

import pony.tpl.Tpl;
class ModelPut extends pony.tpl.TplPut<Model, CPQ> {
	
	private var list:Hash<ITplPut>;
	
	@NotAsyncAuto
	public function new(o:Model, d:CPQ, parent:ITplPut) {
		super(o, d, parent);
		list = data.actions.map(function(v:Action):ITplPut return v.tpl(d, parent));
	}
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		if (list.exists(name))
			return list.get(name).tag(name, content, arg, args, kid);
		else
			return super.tag(name, content, arg, args, kid);
	}
	
}