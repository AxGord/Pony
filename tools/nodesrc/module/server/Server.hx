package module.server;

import types.ServerConfig;
import remote.server.ServerRemote;

/**
 * Server
 * @author AxGord <axgord@gmail.com>
 */
class Server extends NModule<ServerConfig> {

	override private function run(cfg: ServerConfig): Void {
		tasks.add();
		if (cfg.port != null && cfg.path != null) {
			tasks.add();
			var http: Http = new Http(cfg.port, cfg.path);
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
		if (cfg.haxe != null) {
			tasks.add();
			var haxe = new Haxe(cfg.haxe);
			haxe.onError << eError;
			haxe.onLog << eLog;
			haxe.init();
		}
		if (cfg.remote != null) {
			tasks.add();
			var remote: ServerRemote = new ServerRemote(cfg.remote);
			remote.onError << eError;
			remote.onLog << eLog;
			remote.init();
		}
		tasks.end();
	}

}