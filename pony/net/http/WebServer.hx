/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.fs.Unit;
import pony.text.tpl.Templates;

typedef Defaults = { template: String, lang: String }
enum EConnect {
	BREAK;
	NOTREG;
	REG(m:ModuleConnect<IModule>);
}

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
	public var usercontent:String;
	
	public function new(dir:Dir, usercontent:String, modules:Array<IModule>, ?defaults:Defaults)
	{
		this.usercontent = usercontent;
		this.defaults = defaults != null ? defaults : {template: 'Default', lang: 'en'};
		this.modules = modules;
		tpl = new Templates(dir, WebServerPut, this);
		_static = dir + 'static';
		
		for (m in modules) m.init(dir, this);
	}
	
	public function connect(connection:IHttpConnection):Void {
		if (connection.end) return;
		if (connection.url != '' && sendStatic(connection)) return;
		
		var cpq = new CPQ(connection, tpl.get(defaults.template), defaults.lang);
		for (m in modules) {
			switch m.connect(cpq) {
				case BREAK: return;
				case REG(obj): cpq.modules[Type.getClassName(Type.getClass(obj))] = obj;
				case NOTREG:
			}
		}
		cpq.run();
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
			} else if (a[0] == 'usercontent') {
				a.shift();
				var p:String = a.join('/');
				var u:Unit = usercontent + p;
				if (u.exists)
					connection.sendFile(u);
				else
					connection.error('Not found');
				return true;
			}
		}
		return false;
	}
	
}