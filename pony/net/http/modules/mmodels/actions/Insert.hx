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
package pony.net.http.modules.mmodels.actions;

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
	override public function action(cpq:CPQ, h:Map<String,String>):Bool
	{
		var ma:Map<Int,Dynamic> = cpq.connection.sessionStorage.get('modelsActions');
		if (ma.exists(id)) {
			cpq.connection.error('Double send');
			return true;
		}
		
		var ca:Array<Dynamic> = [];
		for (k in args.keys()) {
			var v:String = h.get(k);
			if (v == null)
				ca.push(null);
			else
				switch (args.get(k)) {
					case 'String': ca.push(StringTools.trim(v));
					case 'Int': ca.push(Std.parseInt(v));
					default: 'Not support';
				}
		}
		//var r:ActResult = call(ca);
		callCheck(ca, function(r:ActResult) {
				trace(r);
			/*switch (r) {
				case OK:
					ma.set(id, { values: new Hash<String>(), result: r } );
				case ERROR(Void):*/
					ma.set(id, {values: h, result: r});
			/*}*/
			cpq.connection.endAction();
		
		});
		return true;
	}
	
	override public function tpl(d:CPQ, parent:ITplPut):ITplPut {
		return new InsertPut(this, d, parent);
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class InsertPut extends pony.text.tpl.TplPut < Insert, CPQ > {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (content == null || args.exists('auto')) {
			var fixList = [];
			if (args.exists('fix'))
				fixList = args.get('fix').split(',');
			var r:String = '';
			var ma:Map<Int, Dynamic> = datad.connection.sessionStorage.get('modelsActions');
			var m = ma.get(data.id);
			if (m == null)
				for (k in data.args.keys()) {
					r += inputE(k, '', fixList.indexOf(k) != -1);
				}
			else
				for (k in data.args.keys()) {
					r += inputE(k, m.values.exists(k) ? m.values.get(k) : '', fixList.indexOf(k) != -1);
				}
			clr();
			return '<form action="" method="POST">' +
				(content != null ? '<div class="capition">' + @await tplData(content) + '</div>' : '') +
				r + '<button>Send</button> <a href="" class="action">Clear</a></form>';
		} else {
			var r:String = @await sub(data, datad, InsertPutSub, content);
			clr();
			return r;
		}
	}
	
	private function clr():Void {
		datad.connection.sessionStorage.get('modelsActions').remove(data.id);
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
		return data.model.columns.get(name).htmlInput(cl, data.name, value);
		/*
		return
			'<input ' + (cl != null?'class="' + cl + '" ':'') +
			'name="' + data.model.name + '.' + data.name + '.' +
			name + '" type="text" value="'+value+'"/>';*/
	}
	
	private function st(arg:String):String {
		var ma:Map<Int, Dynamic> = datad.connection.sessionStorage.get('modelsActions');
		var m = ma.get(data.id);
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
class InsertPutSub extends pony.text.tpl.TplPut < Insert, CPQ > {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		//trace(data.args);
		if (data.args.exists(name)) {
			return @await sub({o: data, arg: name}, datad, InsertPutArg, content);
		} else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class InsertPutArg extends pony.text.tpl.TplPut < {o: Insert, arg: String}, CPQ > {
	
	private function st():String {
		var ma:Map<Int, Dynamic> = datad.connection.sessionStorage.get('modelsActions');
		var m = ma.get(data.o.id);
		var r:ActResult = m == null ? null : m.result;
		var st:String = null;
		if (r != null) switch (r) {
			case OK: st = '';
			case ERROR(e):
				if (e.exists(data.arg))
					st = e.get(data.arg);
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
			var ma:Map<Int, Dynamic> = datad.connection.sessionStorage.get('modelsActions');
			var m = ma.get(data.o.id);
			if (m == null)
				return '';
			else {
				//trace(m.values);
				return m.values.exists(data.arg) ? m.values.get(data.arg) : '';
			}
		} else {
			return @await super.shortTag(name, arg, kid);
		}
	}
	
}