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
package pony.net.http.modules.mlang;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;
import pony.text.tpl.TplSystem.Manifest;

/**
 * MLangPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MLangPut extends TplPut<MLangConnect, {}> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'l') {
			if (args.exists('not'))
				return a.cpq.lang == args.get('not') ? '' : @await tplData(content);
			else {
				var d:String = kid != null ? @await kid.tplData(content) : @await tplData(content);
				return l(d, args);
			}
		} else if (name == 'languages') {
			return @await many(null, a.base.langTable.langs.keys(), MLangPutSub, content, arg);
		} else if (name == 'language')
			return @await sub(this, a.cpq.lang, MLangPutSub, content);
		else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'language':
				return a.cpq.lang;
			case 'languages':
				return @await TplPut.manyEasy(null, a.base.langTable.langs.keys(), null, arg == null ? ', ' : arg);
			default:
				return @await super.shortTag(name, arg, kid);
		}
	}
	
	private function l(d:String, args:Map<String, String>):String {
		var m:Manifest = a.cpq.template.manifest;
		var from:String = args.exists('from') ? args.get('from') : (m != null && m.language != null ? m.language : a.base.server.defaults.lang);
		var to:String = args.exists('to') ? args.get('to') : a.cpq.lang;
		return a.base.langTable.translate(from, to, d);
	}
	
}