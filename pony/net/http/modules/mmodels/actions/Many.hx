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
package pony.net.http.modules.mmodels.actions;

import pony.net.http.modules.mmodels.Action;
import pony.tpl.ITplPut;
import pony.net.http.WebServer;

using pony.Ultra;

class Many extends Action
{

	override public function tpl(d:CPQ, parent:ITplPut):ITplPut {
		return new ManyPut(this, d, parent);
	}
	
}

import pony.tpl.Tpl;
class ManyPut extends pony.tpl.TplPut<Many, CPQ> {
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		var r:pony.Stream<Dynamic> = data.call([]);//Reflect.callMethod(data.model, Reflect.field(data.model, name), []);
		var a:Array<Dynamic> = r.array();
		if (args.exists('!'))
			return a.length == 0 ? parent.tplData(content) : '';
		else {
			if (args.exists('div')) {
				return div(arg, args, a);
			} else
				return many(a, ManyPutSub, content, arg);
		}
	}
	
	@NotAsyncAuto
	private function div(arg:String, args:Hash<String>, a:Array<Dynamic>):String {
		var n:String = args.get('div') == null ? 'many' : args.get('div');
		var na:Array<String> = [];
		if (args.exists('cols')) for (e in a){
			var s:String = '<div class="' + n + '">';
			for (f in args.get('cols').split(',').map(StringTools.trim))
				s += '<div class="' + f + '">'
					+ prepare(Reflect.field(e, f))
					+ '</div>';
			s += '</div>';
			na.push(s);
		} else for (e in a) {
			var s:String = '<div class="' + n + '">';
			for (f in Reflect.fields(e))
				s += '<div class="' + f + '">'
					+ prepare(Reflect.field(e, f))
					+ '</div>';
			s += '</div>';
			na.push(s);
		}
		return na.join(arg == null ? '' : arg);
	}
	
	@NotAsyncAuto
	private static function prepare(s:String):String {
		return StringTools.replace(StringTools.htmlEscape(Std.string(s)), '\r\n', '<br/>');
	}
	
}

import pony.tpl.Valuator;
class ManyPutSub extends Valuator<ManyPut, Dynamic> {
	
	override public function valu(name:String, arg:String):String {
		if (Reflect.hasField(datad, name))
			return Std.string(Reflect.field(datad, name));
		else
			return null;
	}
	
}