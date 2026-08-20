package pony.net.http.modules.mmodels.actions;

import pony.Pair;
import pony.net.http.WebServer.EConnect;
import pony.net.http.modules.mmodels.Model.ActResult;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

using StringTools;
using pony.text.TextTools;

/**
 * Update
 * @author AxGord <axgord@gmail.com>
 */
class Update extends Action {

	override public function connect(cpq: CPQ, modelConnect: ModelConnect): Pair<EConnect, ISubActionConnect> {
		final obj = new UpdateConnect(this, cpq, modelConnect);
		return new Pair(REG(cast obj), cast obj);
	}

}

/**
 * UpdateConnect
 * @author AxGord <axgord@gmail.com>
 */
class UpdateConnect extends ActionConnect implements ISubActionConnect {

	public var storage(get, never): Map<Int, Dynamic>;

	private function get_storage(): Map<Int, Dynamic> {
		return cpq.connection.sessionStorage.get('modelsActions');
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function clr(): Void storage.remove(base.id);

	public function subtpl(parent: ITplPut, data: Dynamic): ITplPut {
		return new UpdatePut(this, data, parent);
	}

	override public function action(h: Map<String, String>): Bool {
		if (storage.exists(base.id)) {
			cpq.connection.error('Double send');
			return true;
		}

		final ca: Array<Dynamic> = [];
		for (k => value in base.args) {
			final v: String = h[k];
			if (Std.is(v, Array)) {
				cpq.connection.error('Array not supported');
				return true;
			}
			if (v == null)
				ca.push(null);
			else
				switch (value) {
					case 'String':
						ca.push(v.trim());
					case 'Int':
						ca.push(Std.parseInt(v));
					case _:
						cpq.connection.error('Type ' + value + ' not supported');
						return true;
				}
		}
		callCheck(ca, function(r: ActResult) {
			storage[base.id] = { values: h, result: r };
			switch r {
				case ActResult.OK: cpq.connection.endAction();
				case _: cpq.connection.endActionPrevPage();
			}
		});
		return true;
	}

	public function st(arg: String): String {
		final m = storage[base.id];
		final r: ActResult = m == null ? null : m.result;
		var st: String = null;
		if (r != null) switch (r) {
			case OK: st = '';
			case ERROR(e): st = e.exists(arg) ? e.get(arg) : '';
			case DBERROR: st = 'DataBase error';
		}
		return st;
	}

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class UpdatePut extends pony.text.tpl.TplPut<UpdateConnect, Dynamic> {

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		if (!a.checkAccess()) return '';
		if (content == null || args.exists('auto')) {
			var fixList = [];
			if (args != null && args.exists('fix')) fixList = args['fix'].split(',');
			var r: String = '';
			final ma: Map<Int, { values: Map<String, String>, result: ActResult }> = cast a.storage;
			final m = ma[a.base.id];
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
			return '<form action="" method="POST">'
				+ (content != null ? '<div class="capition">' + @await tplData(content) + '</div>' : '') + r
				+ '<button>Send</button> <a href="" class="action">Clear</a></form>';
		}
		trace(name);
		trace('------------');
		final r: String = @await sub(a, b, UpdatePutSub, content);
		a.clr();
		return r;
	}

	private function inputE(name: String, value: String, fix: Bool): String {
		if (a.base.model.columns.get(name).hid) return input(name, null, value);
		final s: String = a.st(name);
		return s == null
			? '<label>' + name.bigFirst() + input(name, null, value) + '</label>'
			: s == ''
				? '<label>' + name.bigFirst() + input(name, 'ok', fix ? value : '') + '</label>'
				: '<label>' + name.bigFirst() + input(name, 'error', value) + '<div>' + s + '</div>' + '</label>';
	}

	private function input(name: String, cl: String, value: String): String {
		return a.base.model.columns.get(name).htmlInput(cl, a.base.name, value);
	}

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class UpdatePutSub extends pony.text.tpl.TplPut<UpdateConnect, Dynamic> {

	@:async
	override public function shortTag(name: String, arg: String, ?kid: ITplPut): String {
		return a.base.args.exists(name) ? Std.string(Reflect.field(b, name)) : @await super.shortTag(name, arg, kid);
	}

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		return a.base.args.exists(name)
			? @await sub({ o: a, arg: name }, Reflect.field(b, name), UpdatePutArg, content)
			: @await super.tag(name, content, arg, args, kid);
	}

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class UpdatePutArg extends pony.text.tpl.TplPut<{ o: UpdateConnect, arg: String }, String> {

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		switch (name) {
			case 'default':
				return a.o.st(a.arg) == null ? @await tplData(content) : '';
			case 'ok':
				return a.o.st(a.arg) == '' ? @await tplData(content) : '';
			case 'error':
				final s = a.o.st(a.arg);
				return s != null && s != '' ? @await tplData(content) : '';
			case _:
				return @await super.tag(name, content, arg, args, kid);
		}
	}

	@:async
	override public function shortTag(name: String, arg: String, ?kid: ITplPut): String {
		switch (name) {
			case 'error':
				final s = a.o.st(a.arg);
				if (s != null)
					return s;
				else
					return '';
			case 'value':
				final ma: Map<Int, Dynamic> = a.o.cpq.connection.sessionStorage.get('modelsActions');
				final m = ma[a.o.base.id];
				if (m == null) {
					return b;
				} else {
					return m.values.exists(a.arg) ? m.values.get(a.arg) : b;
				}
			case _:
				return @await super.shortTag(name, arg, kid);
		}
	}

}
