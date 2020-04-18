package pony.net.http;

import haxe.Log;
import haxe.PosInfos;
import pony.db.mysql.MySQL;
import pony.magic.Classes;
import pony.net.http.DefaultModulePack;
import pony.net.http.HttpServer;
import pony.net.http.modules.mvk.MVK;
import pony.net.http.modules.mmodels.DefaultActionsPack;
import pony.net.http.modules.mmodels.MModels;
import pony.net.http.modules.mmodels.Model;
import pony.net.http.WebServer;
import pony.Pair;
import pony.fs.Dir;
import pony.fs.File;
import haxe.Json;

typedef SiteConfig = {
	> pony.db.mysql.Config,
	httpport: Int,
	?vk: Pair<Int, String>
}

class SimpleWeb {

	#if php
	private var trc: Array<Pair<Dynamic, PosInfos>> = [];

	private function phpLog(v: Dynamic, ?p: PosInfos): Void
		trc.push(new Pair(v, p));
	#end

	public function new(classes: Array<Class<Model>>, ?json: File, ?config: SiteConfig) {
		#if php
		Log.trace = phpLog;
		#end

		if (json != null && json.exists) config = Json.parse(json.content);

		var db: MySQL = null;
		if (config == null && Config.mysql != null && !Lambda.empty(Config.mysql)) {
			config = {
				host: Config.mysql['host'],
				port: Std.parseInt(Config.mysql['port']),
				user: Config.mysql['user'],
				password: Config.mysql['password'],
				database: Config.mysql['database'],
				httpport: Config.port,
				vk: getVKPair()
			};
		}

		if (config != null) {
			db = new MySQL(config);
			db.onLog << Log.trace;
			db.onError << Log.trace;
		} else {
			config = {
				httpport: Config.port,
				database: null,
				vk: getVKPair()
			};
		}

		var modules: Array<IModule> = DefaultModulePack.create();
		if (db != null) modules.push(cast new MModels(classes, DefaultActionsPack.list, db));
		if (config.vk != null) modules.push(cast new MVK(config.vk.a, config.vk.b));

		var httpServer: HttpServer = new HttpServer(config.httpport);
		var usercontent: String = 'usercontent';
		(usercontent : Dir).create();
		var webServer: WebServer = new WebServer(['home', pony.Tools.ponyPath() + 'webdefaults'], usercontent, modules);
		httpServer.request = webServer.connect;

		#if php
		httpServer.run(new pony.net.http.ServersideStorageDB(db.storage));
		if (trc.length > 0) {
			php.Lib.print('<hr><pre>');
			for (p in trc)
				php.Lib.println(p.b.fileName + ':' + p.b.lineNumber + ': ' + p.a);
		}
		#end
	}

	private static inline function getVKPair(): Pair<Int, String>
		return !Lambda.empty(Config.vk) ? new Pair(Std.parseInt(Config.vk['appid']), Config.vk['secret']) : null;

}