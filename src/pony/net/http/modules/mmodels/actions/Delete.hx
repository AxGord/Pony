package pony.net.http.modules.mmodels.actions;

import pony.Pair;
import pony.net.http.WebServer.EConnect;
import pony.net.http.modules.mmodels.Model.ActResult;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

using pony.text.TextTools;

/**
 * Delete
 * @author AxGord <axgord@gmail.com>
 */
class Delete extends Action {

	override public function connect(cpq: CPQ, modelConnect: ModelConnect): Pair<EConnect, ISubActionConnect> {
		var obj = new DeleteConnect(this, cpq, modelConnect);
		return new Pair(REG(cast obj), cast obj);
	}

}

class DeleteConnect extends ActionConnect implements ISubActionConnect {

	public var storage(get, never): Map<Int, Dynamic>;

	private function get_storage(): Map<Int, Dynamic> {
		return cpq.connection.sessionStorage.get('modelsActions');
	}

	public function subtpl(parent: ITplPut, data: Dynamic): ITplPut {
		return new DeletePut(this, data, parent);
	}

	override public function action(h: Map<String, String>): Bool {
		if (storage.exists(base.id)) {
			cpq.connection.error('Double send');
			return true;
		}

		var ca: Array<Dynamic> = [];
		for (k in base.args.keys()) {
			var v: String = h.get(k);
			if (Std.is(v, Array)) {
				cpq.connection.error('Array not supported');
				return true;
			}
			if (v == null)
				ca.push(null);
			else
				switch (base.args.get(k)) {
					case 'String':
						ca.push(StringTools.trim(v));
					case 'Int':
						ca.push(Std.parseInt(v));
					default:
						cpq.connection.error('Type ' + base.args.get(k) + ' not supported');
						return true;
				}
		}
		call(ca, function(b: Bool) {
			clr();
			if (!b) trace('Delete error');
			if (b)
				cpq.connection.endAction();
			else
				cpq.connection.endActionPrevPage();
		});
		return true;
	}

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	public inline function clr(): Void storage.remove(base.id);

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class DeletePut extends pony.text.tpl.TplPut<DeleteConnect, Dynamic> {

	@:async
	override public function shortTag(name: String, arg: String, ?kid: ITplPut): String {
		return @await tag(name, null, arg, new Map(), kid);
	}

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		if (!a.checkAccess())
			return '';
		if (content == null || args.exists('auto')) {
			var fixList = [];
			if (args.exists('fix'))
				fixList = args.get('fix').split(',');
			var r: String = '';
			var ma: Map<Int, Dynamic> = a.storage;
			var m = ma.get(a.base.id);
			if (m == null)
				for (k in a.base.args.keys()) {
					r += input(k, Reflect.field(b, k));
				}
			else
				for (k in a.base.args.keys()) {
					r += input(k, m.values.exists(k) ? m.values.get(k) : '');
				}
			a.clr();
			return '<form action="" method="POST">$r<button>' + (content != null ? @await tplData(content) : 'Delete') + '</button></form>';
		} else {
			var r: String = @await sub(a, b, DeletePutSub, content);
			a.clr();
			return 'Not supported';
		}
	}

	private function input(name: String, value: String): String {
		return a.base.model.columns.get(name).htmlInput(null, a.base.name, value, true);
	}

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(':async'))
class DeletePutSub extends pony.text.tpl.TplPut<DeleteConnect, Dynamic> {

	@:async
	override public function tag(name: String, content: TplData, arg: String, args: Map<String, String>, ?kid: ITplPut): String {
		return Reflect.field(b, name);
	}

}