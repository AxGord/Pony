package pony.net.http.modules.mmodels;

import pony.db.mysql.MySQL;
import pony.net.http.IModule;
import pony.text.tpl.Tpl;
import pony.net.http.WebServer;
import pony.fs.Dir;
import pony.Stream;
import pony.text.tpl.TplData;

using pony.Tools;
using Lambda;

/**
 * MModels
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MModels implements IModule
{
	public var lastActionId:Int;
	public var list:Map<String, Model>;
	public var db:MySQL;

	public function new(models:Array<Dynamic>, actions:Array<Dynamic>, db:MySQL) {
		this.db = db;

		lastActionId = 0;
		var actionsH = new Map<String, Dynamic>();
		for (cl in actions) {
			var n:String = Type.getClassName(cl);
			actionsH.set(n.substr(n.lastIndexOf('.')+1), cl);
		}
		list = new Map<String, Model>();
		for (m in models) {
			var n:String = Type.getClassName(m);
			n = n.substr(n.lastIndexOf('.')+1);
			if (!list.exists(n))
				list.set(n, Type.createInstance(m, [this, actionsH]));
		}

		db.connected.wait(dbReady);
	}


	private function dbReady():Void {
		trace('connected to db');
		prepare(function() trace('created'));
	}

	@:async
	private function prepare():Void {
		for (m in list) @await m.prepare();
	}

	public function init(dir:Dir, server:WebServer):Void {
	}

	public function connect(cpq:CPQ):EConnect {
		if (!cpq.connection.sessionStorage.exists('modelsActions'))
			cpq.connection.sessionStorage.set('modelsActions', new Map<Int, Dynamic>());

		var connectList:Map<String, ModelConnect> = new Map();

		for (k in list.keys())
			switch (list[k].connect(cpq)) {
				case BREAK: return BREAK;
				case REG(obj): connectList[k] = cast obj;
				case NOTREG:
			}

		var post:Map<String, String> = cpq.connection.mix();
		var h = new Map<String, Map<String, Map<String, String>>>();
		for (k in post.keys()) {
			var a:Array<String> = k.split('.');
			if (a.length == 3) {
				if (!h.exists(a[0]))
					h.set(a[0], new Map<String, Map<String, String>>());
				if (!h.get(a[0]).exists(a[1]))
					h.get(a[0]).set(a[1], new Map<String, String>());
				h.get(a[0]).get(a[1]).set(a[2], post.get(k));
			}
		}
		for (k in h.keys())
			if (list.exists(k))
				if (connectList[k].action(h.get(k))) return BREAK;
		return REG(cast new MModelsConnect(this, cpq, connectList));
	}

}