package module.server;

import sys.FileSystem;
import js.Node;
import js.Error;
import js.node.Http;
import js.node.http.ServerResponse;
import js.node.http.IncomingMessage;
import js.node.fs.WriteStream;
import js.node.Fs;
import types.ProxyConfig;
import pony.Logable;
import pony.NPM;

class Proxy extends Logable {

	private var cachePath: String;
	private var requested: Array<String> = [];
	private var target: String;
	private var port: UInt;
	private var slow: Null<UInt>;
	private var httpPort: Null<UInt>;
	private var httpPath: Null<String>;
	private var proxy: Dynamic;

	public function new(cfg: ProxyConfig, httpPort: Null<UInt>, httpPath: Null<String>) {
		super();
		cachePath = cfg.cache;
		target = cfg.target;
		port = cfg.port;
		slow = cfg.slow;
		this.httpPort = httpPort;
		this.httpPath = httpPath;
	}

	public function init(): Void {
		log('Start proxy server on ${port} to ${target} target');
		if (slow == null && cachePath == null) {
			NPM.http_proxy.createProxyServer({
				target: target,
				headers: {'Host': '127.0.0.1:${port}'}
			}).on('error', errorHandler).listen(port);
		} else {
			proxy = NPM.http_proxy.createProxyServer();
			if (cachePath != null)
				proxy.on('proxyRes', proxyResHandler);
			if (slow != null)
				Http.createServer(httpSlowServerHandler).listen(port);
			else if (cachePath != null)
				Http.createServer(httpCacheServerHandler).listen(port);
			else
				throw 'error';
		}
	}

	private function errorHandler(err: Error, req: IncomingMessage, res: ServerResponse): Void {
		res.writeHead(500, {
			'Content-Type': 'text/plain'
		});
		res.end('Something went wrong.');
	}

	private function proxyResHandler(proxyRes: IncomingMessage, req: IncomingMessage, res: ServerResponse): Void {
		var rpath: String = cachePath + req.url;
		rpath = StringTools.replace(rpath, '//', '/').split('?')[0];
		if (!FileSystem.exists(rpath) && requested.indexOf(rpath) == -1) {
			Utils.createPath(rpath);
			requested.push(rpath);
			var file: WriteStream = Fs.createWriteStream(rpath);
			proxyRes.pipe(file);
		}
	}

	private function httpSlowServerHandler(req: IncomingMessage, res: ServerResponse): Void {
		log('Slow proxy request: ' + target);
		Node.setTimeout(function () {
			proxy.web(req, res, {
				target: target,
				changeOrigin: true
			});
		}, slow);
	}

	private function httpCacheServerHandler(req: IncomingMessage, res: ServerResponse): Void {
		log('Proxy request: ' + req.url);
		var rpath: String = cachePath + req.url;
		rpath = StringTools.replace(rpath, '//', '/').split('?')[0];
		if (FileSystem.exists(rpath)) {
			if (httpPath != null && cachePath == httpPath)
				proxy.web(req, res, cast {
					target: 'http://127.0.0.1:$httpPort',
					changeOrigin: true
				});
			else
				throw 'sorry';
		} else {
			req.headers.remove('accept-encoding');
			proxy.web(req, res, cast {
				target: target,
				changeOrigin: true
			});
		}
	}

}