package pony.net.http.modules.mmodels.actions;

import pony.Pair;
import pony.net.http.CPQ;
import pony.net.http.WebServer;
import pony.net.http.modules.mmodels.Action;
import pony.net.http.modules.mmodels.Model;
import pony.net.http.modules.mmodels.ModelConnect;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplData;

using StringTools;
using Lambda;
using pony.text.TextTools;

/**
 * Insert
 * @author AxGord <axgord@gmail.com>
 */
class Insert extends Action {

	override public function connect(cpq: CPQ, modelConnect: ModelConnect): Pair<EConnect, ISubActionConnect> {
		return new Pair(REG(cast new InsertConnect(this, cpq, modelConnect)), null);
	}

}

/**
 * InsertConnect
 * @author AxGord <axgord@gmail.com>
 */
class InsertConnect extends ActionConnect {

	public var storage(get, never): Map<Int, Dynamic>;

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private inline function get_storage(): Map<Int, Dynamic> {
		return cpq.connection.sessionStorage.get('modelsActions');
	}

	override public function tpl(parent: ITplPut): ITplPut {
		return new InsertPut(this, cpq, parent);
	}

	override public function action(h: Map<String, String>): Bool {
		final ma: Map<Int, Dynamic> = storage;
		if (ma.exists(base.id)) {
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
			ma[base.id] = { values: h, result: r };
			switch r {
				case ActResult.OK: cpq.connection.endAction();
				case _: cpq.connection.endActionPrevPage();
			}
		});
		return true;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function clr(): Void {
		storage.remove(base.id);
	}

}

/**
 * InsertPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class InsertPut extends pony.text.tpl.TplPut<InsertConnect, CPQ> {

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		if (!a.checkAccess()) return '';
		if (content == null || args.exists('auto')) {
			var fixList = [];
			if (args.exists('fix')) fixList = args['fix'].split(',');
			var r: String = '';
			var hasFile: Bool = false;
			final ma: Map<Int, { values: Map<String, String>, result: ActResult }> = cast a.storage;
			final m = ma[a.base.id];
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
			final f = hasFile ? ' enctype="multipart/form-data"' : '';
			return '<form action="" method="POST"$f>'
				+ (content != null ? '<div class="capition">' + @await tplData(content) + '</div>' : '') + r
				+ '<button>Send</button> <a href="" class="action">Clear</a></form>';
		}
		final r: String = @await sub(a, b, InsertPutSub, content);
		a.clr();
		return r;
	}

	private function inputE(name: String, value: String, fix: Bool): String {
		final s: String = st(name);
		return s == null
			? '<label>' + name.bigFirst() + input(name, null, value) + '</label>'
			: s == ''
				? '<label>' + name.bigFirst() + input(name, 'ok', fix ? value : '') + '</label>'
				: '<label>' + name.bigFirst() + input(name, 'error', value) + '<div>' + s + '</div>' + '</label>';
	}

	private function input(name: String, cl: String, value: String): String {
		return a.base.model.columns[name].htmlInput(cl, a.base.name, value);
	}

	private function isFile(name: String): Bool return a.base.model.columns[name].isFile;

	private function st(arg: String): String {
		final ma: Map<Int, Dynamic> = b.connection.sessionStorage.get('modelsActions');
		final m = ma[a.base.id];
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
class InsertPutSub extends pony.text.tpl.TplPut<InsertConnect, CPQ> {

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		return a.base.args.exists(name)
			? @await sub({ o: a, arg: name }, b, InsertPutArg, content)
			: @await super.tag(name, content, arg, args, kid);
	}

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class InsertPutArg extends pony.text.tpl.TplPut<{ o: InsertConnect, arg: String }, CPQ> {

	private function st(): String {
		final ma: Map<Int, { values: Map<String, String>, result: ActResult }> = b.connection.sessionStorage.get('modelsActions');
		final m = ma[a.o.base.id];
		final r: ActResult = m == null ? null : m.result;
		var st: String = null;
		if (r != null) switch (r) {
			case OK: st = '';
			case ERROR(e): st = e.exists(a.arg) ? e.get(a.arg) : '';
			case DBERROR: st = 'DataBase error';
		}
		return st;
	}

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		switch (name) {
			case 'default':
				return st() == null ? @await tplData(content) : '';
			case 'ok':
				return st() == '' ? @await tplData(content) : '';
			case 'error':
				final s = st();
				return s != null && s != '' ? @await tplData(content) : '';
			case _:
				return @await super.tag(name, content, arg, args, kid);
		}
	}

	@:async
	override public function shortTag(name: String, arg: String, ?kid: ITplPut): String {
		if (name == 'error') {
			final s = st();
			return s != null ? s : '';
		}
		if (name == 'value') {
			final ma: Map<Int, { values: Map<String, String>, result: ActResult }> = b.connection.sessionStorage.get('modelsActions');
			final m = ma[a.o.base.id];
			if (m == null)
				return '';
			else {
				// trace(m.values);
				return m.values.exists(a.arg) ? m.values.get(a.arg) : '';
			}
		} else {
			return @await super.shortTag(name, arg, kid);
		}
	}

}
