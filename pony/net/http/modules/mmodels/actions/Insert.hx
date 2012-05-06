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
import pony.net.http.WebServer;
import pony.net.http.modules.mmodels.Model;
import pony.tpl.ITplPut;

using pony.Ultra;

class Insert extends Action
{
	override public function action(cpq:CPQ, h:Hash<String>):Bool
	{
		var ma:IntHash<Dynamic> = cpq.connection.sessionStorage.get('modelsActions');
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
		callAsync(ca, function(r:ActResult) {
				trace(r);
			/*switch (r) {
				case OK:
					ma.set(id, { values: new Hash<String>(), result: r } );
				case ERROR(Void):*/
					ma.set(id, {values: h, result: r});
			/*}*/
			cpq.connection.endAction();
		
		}, cpq.connection.error);
		return true;
	}
	
	override public function tpl(d:CPQ, parent:ITplPut):ITplPut {
		return new InsertPut(this, d, parent);
	}
	
}

using Lambda;

import pony.tpl.Tpl;
class InsertPut extends pony.tpl.TplPut < Insert, CPQ > {
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		if (content == null || args.exists('auto')) {
			var fixList = [];
			if (args.exists('fix'))
				fixList = args.get('fix').split(',');
			var r:String = '';
			var ma:IntHash<Dynamic> = datad.connection.sessionStorage.get('modelsActions');
			var m = ma.get(data.id);
			if (m == null)
				for (k in data.args.keys()) {
					r += inputE(k, '', fixList.indexOf(k) != -1);
				}
			else
				for (k in data.args.keys()) {
					r += inputE(k, m.values.exists(k) ? m.values.get(k) : '', fixList.indexOf(k) != -1);
				}
			var n = clr();
			return '<form action="" method="POST">' +
				(content != null ? '<div class="capition">' + tplData(content) + '</div>' : '') +
				r + '<button>Send</button> <a href="" class="action">Clear</a></form>';
		} else {
			var r:String = sub(data, datad, InsertPutSub, content);
			var n = clr();
			return r;
		}
	}
	
	@NotAsyncAuto
	private function clr():Void {
		datad.connection.sessionStorage.get('modelsActions').remove(data.id);
	}
	@NotAsyncAuto
	private function inputE(name:String, value:String, fix:Bool):String {
		var s:String = st(name);
		if (s == null)
			return '<label>' + name.bigFirst() + input(name, null, value)+'</label>';
		if (s == '')
			return '<label>' + name.bigFirst() + input(name, 'ok', fix ? value : '')+'</label>';
		return '<label>' + name.bigFirst() + input(name, 'error', value)+'<div>'+s+'</div>'+'</label>';
	}
	@NotAsyncAuto
	private function input(name:String, cl:String, value:String):String {
		return data.model.columns.get(name).htmlInput(cl, data.name, value);
		/*
		return
			'<input ' + (cl != null?'class="' + cl + '" ':'') +
			'name="' + data.model.name + '.' + data.name + '.' +
			name + '" type="text" value="'+value+'"/>';*/
	}
	@NotAsyncAuto
	private function st(arg:String):String {
		var ma:IntHash<Dynamic> = datad.connection.sessionStorage.get('modelsActions');
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

class InsertPutSub extends pony.tpl.TplPut < Insert, CPQ > {
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		//trace(data.args);
		if (data.args.exists(name)) {
			return sub({o: data, arg: name}, datad, InsertPutArg, content);
		} else
			return super.tag(name, content, arg, args, kid);
	}
	
	
}

class InsertPutArg extends pony.tpl.TplPut < {o: Insert, arg: String}, CPQ > {
	
	private function st():String {
		var ma:IntHash<Dynamic> = datad.connection.sessionStorage.get('modelsActions');
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
	
	override public function tag(name:String, content:TplData, arg:String, args:Hash<String>, ?kid:ITplPut):String
	{
		switch (name) {
			case 'default':
				return st() == null ? tplData(content) : '';
			case 'ok':
				return st() == '' ? tplData(content) : '';
			case 'error':
				var s = st();
				return s != null && s != '' ? tplData(content) : '';
			default:
				return super.tag(name, content, arg, args, kid);
		}
	}
	
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		if (name == 'error') {
			var s = st();
			if (s != null)
				return s;
			else
				return '';
		} else if (name == 'value') {
			var ma:IntHash<Dynamic> = datad.connection.sessionStorage.get('modelsActions');
			var m = ma.get(data.o.id);
			if (m == null)
				return '';
			else {
				//trace(m.values);
				return m.values.exists(data.arg) ? m.values.get(data.arg) : '';
			}
		} else {
			return super.shortTag(name, arg, kid);
		}
	}
	
}