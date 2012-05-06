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
package pony.tpl;

import pony.tpl.Tpl;
import pony.tpl.TplPut;
import pony.tpl.ValuePut;

class Valuator<C1, C2> extends TplPut<C1, C2> {

	@NotAsyncAuto
	public function new(data:C1, datad:C2, parent:ITplPut = null) {//How make this in Declarator?
		super(data, datad, parent);
	}
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		var b:Bool = valuBool(name);
		if (b != null) {
			if (args.exists('!'))
				return b ? '' : tplData(content);
			else
				return b ? tplData(content) : '';
		} else {
			var v:String = valu(name, arg);
			if (args.exists('htmlEscape'))
				v = StringTools.htmlEscape(v);
			if (v != null) {
				
				if (v == '') {
					if (args.exists('!'))
						return tplData(content);
					else
						return '';
				} else if (!args.exists('!'))
					return sub(v, null, ValuePut, content);
				else
					return '';
			} else
				return super.tag(name, content, arg, args, kid);
		}
	}
	
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		var v:String = valu(name, arg);
		if (v != null)
			return v;
		else
			return super.shortTag(name, arg, kid);
	}
	
	public function valu(name:String, arg:String):String {
		return null;
	}
	
	public function valuBool(name:String):Bool {
		return null;
	}
	
}