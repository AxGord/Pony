/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
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
**/
package pony.text.tpl;

import pony.magic.Declarator;
import pony.text.tpl.Parse;
import pony.text.tpl.style.DefaultStyle;
import pony.text.tpl.TplData;
import pony.text.tpl.ITplPut;

/**
 * Tpl
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class Tpl
{
	
	private var data:TplData;
	private var c:Class<ITplPut>;
	private var o:Dynamic;
	
	public function new(?c:Class<ITplPut>, o:Dynamic, t:String, ?s:TplStyle)
	{
		this.c = c;
		this.o = o;
		if (s == null) s = DefaultStyle.get;
		data = Parse.parse(t, s);
	}
	
	@:async
	public function gen(?d:Dynamic, ?p:ITplPut):String {
		return @await go(o, d, p, c, data);
	}
	
	@:async
	public static function go(o:Dynamic, d:Dynamic, p:ITplPut, ?c:Class<ITplPut>, content:TplData):String {
		if (c == null) {
			c = o.tplPut;
			if (c == null)
				throw 'Need tplPut';
		}
		var r:ITplPut = Type.createInstance(c, [o,d,p]);
		return @await r.tplData(content);
	}
	
}