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

import pony.text.tpl.Tpl;
import pony.text.tpl.TplPut;
import pony.text.tpl.ValuePut;

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class Valuator<C1, C2> extends TplPut<C1, C2> {

	public function new(data:C1, datad:C2, parent:ITplPut = null) {
		super(data, datad, parent);
	}
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		var b:Bool = @await valuBool(name);
		if (b != null) {
			if (args.exists('!'))
				return b ? '' : @await tplData(content);
			else
				return b ? @await tplData(content) : '';
		} else {
			var v:String = @await valu(name, arg);
			if (v != null) {
				if (args.exists('htmlEscape'))
					v = StringTools.htmlEscape(v);
				if (v == '') {
					if (args.exists('!'))
						return @await tplData(content);
					else
						return '';
				} else if (!args.exists('!'))
					return @await sub(v, null, ValuePut, content);
				else
					return '';
			} else
				return @await super.tag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		var v:String = @await valu(name, arg);
		if (v != null)
			return v;
		else
			return @await super.shortTag(name, arg, kid);
	}
	
	@:async
	public function valu(name:String, arg:String):String {
		return null;
	}
	
	@:async
	public function valuBool(name:String):Bool {
		return null;
	}
	
}