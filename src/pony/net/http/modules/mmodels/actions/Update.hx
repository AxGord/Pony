package pony.net.http.modules.mmodels.actions;

import pony.Pair;
import pony.net.http.WebServer.EConnect;
import pony.net.http.modules.mmodels.Model.ActResult;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

using pony.text.TextTools;

/**
 * Update
 * @author AxGord <axgord@gmail.com>
 */
class Update extends Action {
	override public function connect(cpq:CPQ, modelConnect:ModelConnect):Pair<EConnect, ISubActionConnect> {
		var obj = new UpdateConnect(this, cpq, modelConnect);
		return new Pair(REG(cast obj), cast obj);
	}
}

/**
 * UpdateConnect
 * @author AxGord <axgord@gmail.com>
 */
class UpdateConnect extends ActionConnect implements ISubActionConnect {
	
	public var storage(get, never):Map<Int, Dynamic>;
	
	private function get_storage():Map<Int, Dynamic> {
		return cpq.connection.sessionStorage.get('modelsActions');
	}
	
	public function subtpl(parent:ITplPut, data:Dynamic):ITplPut {
		return new UpdatePut(this, data, parent);
	}
	
	override public function action(h:Map<String, String>):Bool {
		if (storage.exists(base.id)) {
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
			storage.set(base.id, {values: h, result: r});
			switch r {
				case ActResult.OK: cpq.connection.endAction();
				case _: cpq.connection.endActionPrevPage();
			}
		});
		return true;
	}
	
	public function st(arg:String):String {
		var m = storage.get(base.id);
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
	
	@:extern inline public function clr():Void storage.remove(base.id);
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class UpdatePut extends pony.text.tpl.TplPut < UpdateConnect, Dynamic > {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (!a.checkAccess()) return '';
		if (content == null || args.exists('auto')) {
			var fixList = [];
			if (args != null && args.exists('fix'))
				fixList = args.get('fix').split(',');
			var r:String = '';
			var ma:Map<Int, {values: Map<String, String>, result: ActResult}> = cast a.storage;
			var m = ma.get(a.base.id);
			if (m == null)
				for (k in a.base.args.keys()) {
					r += inputE(k, Reflect.field(b, k), fixList.indexOf(k) != -1);
				}
			else
				for (k in a.base.args.keys()) {
					trace(m.values.get(k));
					r += inputE(k, m.values.exists(k) ? m.values.get(k) : '', fixList.indexOf(k) != -1);
				}
			a.clr();
			return '<form action="" method="POST">' +
				(content != null ? '<div class="capition">' + @await tplData(content) + '</div>' : '') +
				r + '<button>Send</button> <a href="" class="action">Clear</a></form>';
		} else {
			trace(name);
			trace('------------');
			var r:String = @await sub(a, b, UpdatePutSub, content);
			a.clr();
			return r;
		}
	}
	
	private function inputE(name:String, value:String, fix:Bool):String {
		if (a.base.model.columns.get(name).hid) return input(name, null, value);
		var s:String = a.st(name);
		if (s == null)
			return '<label>' + name.bigFirst() + input(name, null, value) + '</label>';
		if (s == '')
			return '<label>' + name.bigFirst() + input(name, 'ok', fix ? value : '') + '</label>';
		return '<label>' + name.bigFirst() + input(name, 'error', value) + '<div>' + s + '</div>' + '</label>';
	}
	
	private function input(name:String, cl:String, value:String):String {
		return a.base.model.columns.get(name).htmlInput(cl, a.base.name, value);
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class UpdatePutSub extends pony.text.tpl.TplPut < UpdateConnect, Dynamic > {
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String {
		if (a.base.args.exists(name))
			return Std.string(Reflect.field(b, name));
		else
			return @await super.shortTag(name, arg, kid);
	}
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (a.base.args.exists(name)) {
			return @await sub({o: a, arg: name}, Reflect.field(b, name), UpdatePutArg, content);
		} else
			return @await super.tag(name, content, arg, args, kid);
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class UpdatePutArg extends pony.text.tpl.TplPut < {o: UpdateConnect, arg: String}, String > {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String,String>, ?kid:ITplPut):String
	{
		switch (name) {
			case 'default':
				return a.o.st(a.arg) == null ? @await tplData(content) : '';
			case 'ok':
				return a.o.st(a.arg) == '' ? @await tplData(content) : '';
			case 'error':
				var s = a.o.st(a.arg);
				return s != null && s != '' ? @await tplData(content) : '';
			default:
				return @await super.tag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		if (name == 'error') {
			var s = a.o.st(a.arg);
			if (s != null)
				return s;
			else
				return '';
		} else if (name == 'value') {
			var ma:Map<Int, Dynamic> = a.o.cpq.connection.sessionStorage.get('modelsActions');
			var m = ma.get(a.o.base.id);
			if (m == null) {
				return b;
			} else {
				return m.values.exists(a.arg) ? m.values.get(a.arg) : b;
			}
		} else {
			return @await super.shortTag(name, arg, kid);
		}
	}
	
}