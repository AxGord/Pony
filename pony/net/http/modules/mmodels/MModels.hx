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

import pony.db.DB;
import pony.net.http.IModule;
import pony.tpl.ITplPut;
import pony.net.http.WebServer;
import pony.fs.Dir;
import pony.Stream;

using pony.Ultra;
using Lambda;

class MModels implements IModule
{
	public var lastActionId:Int;
	public var list:Hash<Model>;
	public var db:DB;
	
	public function new(models:Array<Dynamic>, actions:Array<Dynamic>, db:DB) {
		this.db = db;
		db.ready(dbReady);
		
		lastActionId = 0;
		var actionsH = new Hash<Dynamic>();
		for (cl in actions) {
			var n:String = Type.getClassName(cl);
			actionsH.set(n.substr(n.lastIndexOf('.')+1), cl);
		}
		list = new Hash<Model>();
		for (m in models) {
			var n:String = Type.getClassName(m);
			n = n.substr(n.lastIndexOf('.')+1);
			if (!list.exists(n))
				list.set(n, Type.createInstance(m, [this, actionsH]));
		}
		
		
	}
	
	private function dbReady():Void {
		db.tablesAsync(ltl);
	}
	
	private function ltl(r:Stream<String>):Void {
		var a:Array<String> = r.array();
		trace(a);
		for (m in list)
			if (a.indexOf(m.name.toLowerCase()) == -1) {
				m.create();
			} else
				m.update();
	}
	
	public function init(dir:Dir, server:WebServer):Void {
	}
	
	public function connect(cpq:CPQ):Bool {
		if (!cpq.connection.sessionStorage.exists('modelsActions'))
			cpq.connection.sessionStorage.set('modelsActions', new IntHash<Dynamic>());
			
		for (m in list)
			if (m.connect(cpq)) return true;
			
		var post:Hash<String> = cpq.connection.mix();
		var h = new Hash<Hash<Hash<String>>>();
		for (k in post.keys()) {
			var a:Array<String> = k.split('.');
			if (a.length == 3) {
				if (!h.exists(a[0]))
					h.set(a[0], new Hash<Hash<String>>());
				if (!h.get(a[0]).exists(a[1]))
					h.get(a[0]).set(a[1], new Hash<String>());
				h.get(a[0]).get(a[1]).set(a[2], post.get(k));
			}
		}
		for (k in h.keys())
			if (list.exists(k))
				if (list.get(k).action(cpq, h.get(k))) return true;
		return false;
	}
	
	public function tpl(d:CPQ, parent:ITplPut):ITplPut {
		return new MModelsPut(this, d, parent);
	}
	
}

import pony.tpl.Tpl;
class MModelsPut extends pony.tpl.TplPut<MModels, CPQ> {
	
	private var list:Hash<ITplPut>;
	
	@NotAsyncAuto
	public function new(o:MModels, d:CPQ, parent:ITplPut) {
		super(o, d, parent);
		list = data.list.map(function(v:Model):ITplPut return v.tpl(d, parent));
	}
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		if (list.exists(name))
			return list.get(name).tplData(content);
		else
			return super.tag(name, content, arg, args, kid);
	}
	
}