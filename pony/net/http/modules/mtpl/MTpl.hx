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
package pony.net.http.modules.mtpl;

import pony.fs.Dir;
import pony.net.http.IHttpConnection;
import pony.net.http.IModule;
import pony.net.http.WebServer;
import pony.text.tpl.Templates;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplSystem;
import pony.text.tpl.Valuator;


/**
 * MTpl
 * @author AxGord
 */

class MTpl implements IModule
{
	public var server:WebServer;
	
	public function new() { }
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
	}
	
	public function connect(cpq:CPQ):Bool {
		if (cpq.connection.params.exists('template')) {
			var tc:String = cpq.connection.params.get('template');
			if (server.tpl.exists(tc)) {
				cpq.connection.sessionStorage.set('template', tc);
				cpq.connection.params.remove('template');
				cpq.connection.endAction();
			} else {
				cpq.connection.error('Not exists template: '+tc);
			}
			return true;
		} else {
			if (cpq.connection.params.exists('tryTemplate'))
				cpq.template = server.tpl.get(cpq.connection.params.get('tryTemplate'));
			else {
				var st:Map<String, Dynamic> = cpq.connection.sessionStorage;
				if (st.exists('template'))
					cpq.template = server.tpl.get(st.get('template'));
			}
			return false;
		}
		
	}
	
	public function tpl(d:CPQ, parent:ITplPut):ITplPut {
		return new MTplPut(this, d, parent);
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class MTplPut extends TplPut<MTpl, CPQ> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'templates') {
			return @await many(data.server.tpl, MTplPutSub, content, arg);
		} else if (name == 'template')
			return @await sub(this, datad.template, MTplPutSub, content);
		else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'template':
				return datad.template.name;
			case 'templates':
				return @await TplPut.manyEasy(data.server.tpl, getName, arg == null ? ', ' : arg);
			default:
				return @await super.shortTag(name, arg, kid);
		}
	}
	
	private static function getName(v:TplSystem, cb:String->Void):Void cb(v.name);
	
}


@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class MTplPutSub extends Valuator<MTplPut, TplSystem> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'selected') return @await super.tag(name, content, arg, args, kid);
		else {
			var r = @await valu(name, arg);
			if (r != null) {
				if (content != null) {
					return @await super1_tag(name, content, arg, args, kid);
				} else 
					return r;
			} else {
				return @await parentTag(name, content, arg, args, kid);
			}
		}
	}
	
	@:async
	override public function valuBool(name:String):Bool {
		if (name == 'selected') {
			var c:CPQ = data.datad;
			return c.template == datad;
		} else
			return null;
	}
	
	@:async
	override public function valu(name:String, arg:String):String {
		var m:Manifest = datad.manifest;
		return switch (name) {
			case 'name': datad.name;
			case 'title': sie(m, 'title', datad.name);
			case 'author': sie(m, 'author');
			case 'email': sie(m, 'email');
			case 'www': sie(m, 'www');
			case 'license': sie(m, 'license');
			case 'version': m != null && m.version != null ? m.version.major + '.' + m.version.minor : '';
			case 'extends':
				if (m != null && m._extends != null)
					@await TplPut.manyEasy(m._extends, null, arg == null ? ', ' : arg);
				else
					'';
			default:
				null;
		}
	}
	
	private static inline function sie(m:Manifest, f:String, r:String=''):String {
		return m != null && Reflect.field(m, f) != null ? Reflect.field(m, f) : r;
	}
	
}

