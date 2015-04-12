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
package pony.net.http;

import pony.fs.Dir;
import pony.fs.File;
import pony.fs.Unit;
import pony.text.tpl.Templates;
import pony.text.tpl.TplData;
import pony.text.tpl.TplSystem;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplPut;
import pony.text.tpl.ITplPut;

typedef Defaults = { template: String, lang: String }
typedef CPQ = {connection: IHttpConnection, page: String, query: Array<String>, template: TplSystem, lang: String}

/**
 * WebServer
 * @author AxGord
 */

class WebServer
{
	public var modules:Array<IModule>;
	public var tpl:Templates;
	public var _static:Dir;
	public var defaults:Defaults;
	
	public function new(dir:Dir, modules:Array<IModule>, ?defaults:Defaults)
	{
		this.defaults = defaults != null ? defaults : {template: 'Default', lang: 'en'};
		this.modules = modules;
		tpl = new Templates(dir, WebServerPut, this);
		_static = dir + 'static';
		
		for (m in modules) m.init(dir, this);
	}
	
	public function connect(connection:IHttpConnection):Void {
		if (connection.end) return;
		if (connection.url != '' && sendStatic(connection)) return;
		
		var cpq:CPQ = {connection: connection, page: '', query: [], template: tpl.get(defaults.template), lang: defaults.lang};
		
		for (m in modules)
			if (m.connect(cpq)) return;

		try {
			var a:Array<String> = connection.url.split('/');
			var u:Array<String> = [];
			while (a.length != 0) {
				var n:String = a.join('/');
				if (cpq.template.exists(n + '/index')) {
					cpq.page = n;
					cpq.query = u;
					gen(n+'/index', cpq);
					return;
				} else if (cpq.template.exists(n)) {
					cpq.page = n;
					cpq.query = u;
					gen(n, cpq);
					return;
				} else
					u.push(a.pop());
			}
			if (cpq.template.exists('index')) {
				cpq.query = u;
				gen('index', cpq);
			} else
				throw 'Not exists index.tpl';
		} /*catch (e:String) {
			connection.error(e);
		} catch (e:Dynamic) {
			connection.error(e);
		}*/
	}
	
	private function sendStatic(connection:IHttpConnection):Bool {
		var u:Unit = _static + connection.url;
		if (u.exists) {
			connection.sendFile(u);
			return true;
		} else {
			var a:Array<String> = connection.url.split('/');
			if (a[0] == 'tpl') {
				a.shift();
				var t:String = a.shift();
				var p:String = a.join('/');
				if (!tpl.exists(t)) connection.error('Not exists template: ' + t);
				else if (!tpl.get(t)._static.exists(p)) connection.error('Not found');
				else
					connection.sendFile(tpl.get(t)._static.get(p));
				return true;
			}
		}
		return false;
	}
	
	private inline function gen(name:String, cpq:CPQ):Void {
		cpq.template.gen(name, cpq, cpq.connection.sendHtml/*, cpq.connection.error*/);
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class WebServerPut extends TplPut<WebServer, CPQ> {
	
	private var t:ITplPut;
	
	public function new(o:WebServer, d:CPQ, parent:ITplPut) {
		super(o, d, parent);
		t = parent;
		for (m in data.modules) {
			t = m.tpl(datad, t);
		}
	}
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		return @await t.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		return @await t.shortTag(name, arg, kid);
	}
	
}