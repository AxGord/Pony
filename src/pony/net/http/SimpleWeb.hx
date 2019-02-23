package pony.net.http;

import haxe.Log;
import haxe.PosInfos;
import pony.db.mysql.MySQL;
import pony.magic.Classes;
import pony.net.http.DefaultModulePack;
import pony.net.http.HttpServer;
import pony.net.http.modules.mmodels.DefaultActionsPack;
import pony.net.http.modules.mmodels.MModels;
import pony.net.http.modules.mmodels.Model;
import pony.net.http.WebServer;
import pony.Pair;

class SimpleWeb {

	#if php
	private var trc:Array<Pair<Dynamic, PosInfos>> = [];
	private function phpLog(v:Dynamic, ?p:PosInfos):Void trc.push(new Pair(v, p));
	#end

	public function new(classes:Array<Class<Model>>) {
		#if php
		Log.trace = phpLog;
		#end

		var db:MySQL = null;
		if (Config.mysql != null && !Lambda.empty(Config.mysql)) {
			db = new MySQL( {
				host: Config.mysql['host'],
				port: Std.parseInt(Config.mysql['port']),
				user: Config.mysql['user'],
				password: Config.mysql['password'],
				database: Config.mysql['database']
			} );
			db.onLog << Log.trace;
			db.onError << Log.trace;
		}

		var modules:Array<IModule> = DefaultModulePack.create();
		if (db != null) {
			modules.push(cast new MModels(classes, DefaultActionsPack.list, db));
		}
		
		var httpServer = new HttpServer(Config.port);
		var webServer:WebServer = new WebServer(['home', pony.Tools.ponyPath() + 'webdefaults'], null, modules);
		httpServer.request = webServer.connect;
		
		#if php
		httpServer.run(new pony.net.http.ServersideStorageDB(db.storage));
		if (trc.length > 0) {
			php.Lib.print('<hr><pre>');
			for (p in trc) php.Lib.println(p.b.fileName + ':' + p.b.lineNumber + ': ' + p.a);
		}
		#end
	}

}