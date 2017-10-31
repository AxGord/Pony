/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.http.modules.mmodels.actions;

import pony.Pair;
import pony.net.http.modules.mmodels.ModelConnect;
import pony.net.http.CPQ;
import pony.net.http.modules.mmodels.Action;
import pony.net.http.WebServer;
import pony.net.http.modules.mmodels.Model;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData;

using pony.text.TextTools;
using Lambda;

class Insert extends Action
{
	override public function connect(cpq:CPQ, modelConnect:ModelConnect):Pair<EConnect, ISubActionConnect> {
		return new Pair(REG(cast new InsertConnect(this, cpq, modelConnect)), null);
	}
}

class InsertConnect extends ActionConnect {
	
	public var storage(get,never):Map<Int,Dynamic>;
	
	@:extern inline private function get_storage():Map<Int,Dynamic> {
		return cpq.connection.sessionStorage.get('modelsActions');
	}
	
	override public function tpl(parent:ITplPut):ITplPut {
		return new InsertPut(this, cpq, parent);
	}
	
	override public function action(h:Map<String, String>):Bool {
		var ma:Map<Int,Dynamic> = storage;
		if (ma.exists(base.id)) {
			cpq.connection.error('Double send');
			return true;
		}
		
		var ca:Array<Dynamic> = [];
		for (k in base.args.keys()) {
			var v:String = h.get(k);
			if (Std.is(v, Array)) {
				cpq.connection.error('Array not supported');
				return true;
			}
			if (v == null)
				ca.push(null);
			else
				switch (base.args.get(k)) {
					case 'String': ca.push(StringTools.trim(v));
					case 'Int': ca.push(Std.parseInt(v));
					default: 
						cpq.connection.error('Type ' + base.args.get(k) + ' not supported');
						return true;
				}
		}
		callCheck(ca, function(r:ActResult) {
			ma.set(base.id, {values: h, result: r});
			switch r {
				case ActResult.OK: cpq.connection.endAction();
				case _: cpq.connection.endActionPrevPage();
			}
		});
		return true;
	}
	
	@:extern inline public function clr():Void {
		storage.remove(base.id);
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class InsertPut extends pony.text.tpl.TplPut < InsertConnect, CPQ > {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (!a.checkAccess()) return '';
		if (content == null || args.exists('auto')) {
			var fixList = [];
			if (args.exists('fix'))
				fixList = args.get('fix').split(',');
			var r:String = '';
			var hasFile:Bool = false;
			var ma:Map<Int, {values:Map<String, String>, result: ActResult}> = cast a.storage;
			var m = ma.get(a.base.id);
			if (m == null)
				for (k in a.base.args.keys()) {
					r += inputE(k, '', fixList.indexOf(k) != -1);
					if (isFile(k)) hasFile = true;
				}
			else
				for (k in a.base.args.keys()) {
					r += inputE(k, m.values.exists(k) ? m.values.get(k) : '', fixList.indexOf(k) != -1);
					if (isFile(k)) hasFile = true;
				}
			a.clr();
			var f = hasFile ? ' enctype="multipart/form-data"' : '';
			return '<form action="" method="POST"$f>' +
				(content != null ? '<div class="capition">' + @await tplData(content) + '</div>' : '') +
				r + '<button>Send</button> <a href="" class="action">Clear</a></form>';
		} else {
			var r:String = @await sub(a, b, InsertPutSub, content);
			a.clr();
			return r;
		}
	}
	
	
	private function inputE(name:String, value:String, fix:Bool):String {
		var s:String = st(name);
		if (s == null)
			return '<label>' + name.bigFirst() + input(name, null, value)+'</label>';
		if (s == '')
			return '<label>' + name.bigFirst() + input(name, 'ok', fix ? value : '')+'</label>';
		return '<label>' + name.bigFirst() + input(name, 'error', value)+'<div>'+s+'</div>'+'</label>';
	}
	
	private function input(name:String, cl:String, value:String):String {
		return a.base.model.columns[name].htmlInput(cl, a.base.name, value);
	}
	
	private function isFile(name:String):Bool return a.base.model.columns[name].isFile;
	
	private function st(arg:String):String {
		var ma:Map<Int, Dynamic> = b.connection.sessionStorage.get('modelsActions');
		var m = ma.get(a.base.id);
		var r:ActResult = m == null ? null : m.result;
		var st:String = null;
		if (r != null) switch (r) {
			case OK: st = '';
			case ERROR(e):
				if (e.exists(arg))
					st = e.get(arg);
				else
					st = '';
			case DBERROR: st = 'DataBase error';
		}
		return st;
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class InsertPutSub extends pony.text.tpl.TplPut < InsertConnect, CPQ > {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (a.base.args.exists(name)) {
			return @await sub({o: a, arg: name}, b, InsertPutArg, content);
		} else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class InsertPutArg extends pony.text.tpl.TplPut < {o: InsertConnect, arg: String}, CPQ > {
	
	private function st():String {
		var ma:Map<Int, {values:Map<String, String>, result: ActResult}> = b.connection.sessionStorage.get('modelsActions');
		var m = ma.get(a.o.base.id);
		var r:ActResult = m == null ? null : m.result;
		var st:String = null;
		if (r != null) switch (r) {
			case OK: st = '';
			case ERROR(e):
				if (e.exists(a.arg))
					st = e.get(a.arg);
				else
					st = '';
			case DBERROR: st = 'DataBase error';
		}
		return st;
	}
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String,String>, ?kid:ITplPut):String
	{
		switch (name) {
			case 'default':
				return st() == null ? @await tplData(content) : '';
			case 'ok':
				return st() == '' ? @await tplData(content) : '';
			case 'error':
				var s = st();
				return s != null && s != '' ? @await tplData(content) : '';
			default:
				return @await super.tag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		if (name == 'error') {
			var s = st();
			if (s != null)
				return s;
			else
				return '';
		} else if (name == 'value') {
			var ma:Map<Int, {values:Map<String, String>, result: ActResult}> = b.connection.sessionStorage.get('modelsActions');
			var m = ma.get(a.o.base.id);
			if (m == null)
				return '';
			else {
				//trace(m.values);
				return m.values.exists(a.arg) ? m.values.get(a.arg) : '';
			}
		} else {
			return @await super.shortTag(name, arg, kid);
		}
	}
	
}