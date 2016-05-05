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
package pony.net.http.modules.mmodels.actions;

import pony.Pair;
import pony.net.http.modules.mmodels.Action;
import pony.net.http.WebServer;
import pony.Stream;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData;
import pony.text.tpl.Valuator;

using pony.Tools;

class Many extends Action
{
	override public function connect(cpq:CPQ, modelConnect:ModelConnect):Pair<EConnect, ISubActionConnect> {
		return new Pair(REG(cast new ManyConnect(this, cpq, modelConnect)), null);
	}
}

class ManyConnect extends ActionConnect {
	
	override public function tpl(parent:ITplPut):ITplPut {
		initTpl();
		return new ManyPut(this, cpq, parent);
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class ManyPut extends pony.text.tpl.TplPut<ManyConnect, CPQ> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (!a.checkAccess()) return '';
		var a:Array<Dynamic> = @await a.call([]);
		if (args.exists('!'))
			return a.length == 0 ? @await parent.tplData(content) : '';
		else {
			if (args.exists('div')) {
				return @await div(arg, args, a);
			} else
				return @await many(a, ManyPutSub, content, arg);
		}
	}
	
	@:async
	private function div(arg:String, args:Map<String, String>, a:Array<Dynamic>):String {
		var n:String = args.get('div') == null ? 'many' : args.get('div');
		var na:Array<String> = [];
		if (args.exists('cols')) for (e in a){
			var s:String = '<div class="' + n + '">';
			for (f in args.get('cols').split(',').map(StringTools.trim))
				s += '<div class="' + f + '">'
					+ @await html(e, f)
					+ '</div>';
			s += '</div>';
			na.push(s);
		} else for (e in a) {
			var s:String = '<div class="' + n + '">';
			for (f in Reflect.fields(e))
				s += '<div class="' + f + '">'
					+ @await html(e, f)
					+ '</div>';
			s += '</div>';
			na.push(s);
		}
		return na.join(arg == null ? '' : arg);
	}
	
	@:async
	private function html(e:Dynamic, f:String):String {
		var c = a.base.model.columns[f];
		if (c.tplPut != null) {
			var o:Dynamic = Type.createInstance(c.tplPut, [c, e, this]);
			return @await o.html(f);
		} else {
			return Reflect.field(e, f);
		}
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class ManyPutSub extends Valuator<ManyPut, Dynamic> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'selected') {
			var f1 = a.a.checkActivePath(b);
			var f2 = !args.exists('!');
			if ((f1 && f2) || (!f1 && !f2))
				return @await tplData(content);
			else
				return '';
		} else {
			if (a.a.base.model.columns.exists(name)) return '%$name%';
			var c = a.a.base.model.columns[name];
			if (c != null && c.tplPut != null) {
				var o = Type.createInstance(c.tplPut, [c, b, this]);
				return @await o.tag(name, content, arg, args, kid);
			} else
				return @await super.tag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String 
	{
		if (!a.a.base.model.columns.exists(name)) return '%$name%';
		var c = a.a.base.model.columns[name];
		if (c != null && c.tplPut != null) {
			var o = Type.createInstance(c.tplPut, [c, b, this]);
			return @await o.shortTag(name, arg, kid);
		} else
			return @await super.shortTag(name, arg, kid);
	}
	
	@:async
	override public function valu(name:String, arg:String):String {
		if (Reflect.hasField(b, name))
			return Std.string(Reflect.field(b, name));
		else
			return null;
	}
	
}