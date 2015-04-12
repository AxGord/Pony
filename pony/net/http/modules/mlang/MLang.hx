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
package pony.net.http.modules.mlang;

import pony.fs.Dir;
import pony.LangTable;
import pony.net.http.IModule;
import pony.net.http.WebServer;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;
import pony.text.tpl.TplSystem;
import pony.text.tpl.Valuator;

class MLang implements IModule
{
	public var server:WebServer;
	public var langTable:LangTable;
	
	public function new() { }
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
		langTable = new LangTable(dir + 'language', server.defaults.lang);
	}
	
	public function connect(cpq:CPQ):Bool {
		if (cpq.connection.params.exists('language')) {
			var tc:String = cpq.connection.params.get('language');
			if (langTable.langs.exists(tc)) {
				cpq.connection.sessionStorage.set('language', tc);
				cpq.connection.params.remove('language');
				cpq.connection.endAction();
			} else {
				cpq.connection.error('Not exists language: '+tc);
			}
			return true;
		} else {
			if (cpq.connection.params.exists('tryLanguage'))
				cpq.lang = cpq.connection.params.get('tryLanguage');
			else {
				var st:Map<String, Dynamic> = cpq.connection.sessionStorage;
				if (st.exists('language'))
					cpq.lang = st.get('language');
				else {
					for (l in cpq.connection.languages)
						if (langTable.langs.exists(l)) {
							cpq.lang = l;
							break;
						}
				}
			}
			return false;
		}
	}
	
	public function tpl(d:CPQ, parent:ITplPut):ITplPut {
		return new MLangPut(this, d, parent);
	}
	
	
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class MLangPut extends TplPut<MLang, CPQ> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		
		if (name == 'l') {
			if (args.exists('not'))
				return datad.lang == args.get('not') ? '' : @await tplData(content);
			else {
				var d:String = kid != null ? @await kid.tplData(content) : @await tplData(content);
				return l(d, args);
			}
		} else if (name == 'languages') {
			return @await many(null, data.langTable.langs.keys(), MLangPutSub, content, arg);
		} else if (name == 'language')
			return @await sub(this, datad.lang, MLangPutSub, content);
		else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'language':
				return datad.lang;
			case 'languages':
				return @await TplPut.manyEasy(null, data.langTable.langs.keys(), null, arg == null ? ', ' : arg);
			default:
				return @await super.shortTag(name, arg, kid);
		}
	}
	
	private function l(d:String, args:Map<String, String>):String {
		var m:Manifest = datad.template.manifest;
		var from:String = args.exists('from') ? args.get('from') : (m != null && m.language != null ? m.language : data.server.defaults.lang);
		var to:String = args.exists('to') ? args.get('to') : datad.lang;
		return data.langTable.translate(from, to, d);
	}
	
}


@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class MLangPutSub extends Valuator<MLangPut, String> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'selected') return @await super1_tag(name, content, arg, args, kid);
		else {
			var r = @await valu(name, arg);
			if (r != null)
				return @await super1_tag(name, content, arg, args, kid);
			else
				return @await parentTag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function valuBool(name:String):Bool {
		if (name == 'selected') {
			var c:CPQ = data.datad;
			return c.lang == datad;
		} else
			return null;
	}
	
	@:async
	override public function valu(name:String, arg:String):String {
		return switch (name) {
			case 'name': datad;
			case 'title': data.data.langTable.langs.get(datad).title;
			case 'author':
				var a:String = data.data.langTable.langs.get(datad).author;
				a != null ? a : '';
			default: null;
		}
	}
	
}

