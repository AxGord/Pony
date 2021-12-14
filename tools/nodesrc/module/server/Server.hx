package module.server;

import pony.time.Time;
import haxe.PosInfos;
import types.ServerConfig;
import remote.server.ServerRemote;

/**
 * Server Pony Tools Node Module
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Server extends NModule<ServerConfig> {

	override private function run(cfg: ServerConfig): Void {
		tasks.add();
		if (@:nullSafety(Off) (cfg.port != null) && cfg.path != null) {
			tasks.add();
			var http: Http = new Http(cast cfg.port, cast cfg.path);
			http.onError << eError;
			http.onLog << eLog;
		}
		for (proxy in cfg.proxy) {
			tasks.add();
			var proxy: Proxy = new Proxy(proxy, cfg.port, cfg.path);
			proxy.onError << eError;
			proxy.onLog << eLog;
			proxy.init();
		}
		if (@:nullSafety(Off) (cfg.haxe != null)) {
			tasks.add();
			var haxe = new Haxe(cast cfg.haxe);
			haxe.onError << eError;
			haxe.onLog << eLog;
			haxe.init();
		}
		if (cfg.remote != null) {
			tasks.add();
			var remote: ServerRemote = new ServerRemote(cast cfg.remote);
			remote.onError << eError;
			remote.onLog << eLog;
			remote.init();
		}
		if (cfg.sniff != null) {
			tasks.add();
			var sniff: Sniff = new Sniff(cast cfg.sniff);
			sniff.onError << errorWithTime;
			sniff.onLog << logWithTime;
			sniff.init();
		}
		tasks.end();
	}

	private function errorWithTime(s: String, ?p: PosInfos): Void error(now() + ' ' + s, p);
	private function logWithTime(s: String, ?p: PosInfos): Void log(now() + ' ' + s, p);

	private function now(): String {
		var d: Date = Date.now();
		#if (haxe_ver >= 4.000)
		var z: Int = d.getTimezoneOffset();
		#else
		var z: Int = untyped __js__('new Date().getTimezoneOffset()');
		#end
		return Time.fromFloat((d.getTime() - z * 60 * 1000) % (24 * 60 * 60 * 1000));
	}

}