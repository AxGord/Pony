package pony.net.http.platform.nodejs;

import js.Node;
import js.node.Fs;
import js.node.Http;
import js.node.http.IncomingMessage;
import js.node.http.Server;
import js.node.http.ServerResponse;
import pony.net.http.IHttpConnection;
import pony.net.http.ServersideStorage;

using Reflect;

/**
 * HttpServer
 * @author AxGord <axgord@gmail.com>
 */
class HttpServer {

	/**
	 * Loaded on the first multipart POST, not when this class is loaded: `multiparty` is
	 * an optional npm package, and requiring it eagerly makes the whole server unusable —
	 * a service that serves JSON and static files never sees a multipart body, yet could
	 * not start without the dependency. Assign it before the first such request to
	 * substitute an implementation.
	 */
	public static var multipartyClass: Null<Class<Dynamic>> = null;

	public static var querystring: Dynamic = Node.require('querystring');

	private static var spdy(get, never): Dynamic;

	/**
	 * Whether to announce the listening address. A service that prints its own startup
	 * line — or has that line parsed by a supervisor — wants this off, and cannot silence
	 * a `trace` any other way.
	 */
	public var verbose: Bool = true;

	public var fixedHeaders: Map<String, String> = ['Server' => 'PonyHttpServer'];
	public var storage: ServersideStorage;

	private var server: Server;
	private var spdyServer: Dynamic;

	public function new(?host: String, port: Int = 80, ?spdyConf: Dynamic) {
		server = Http.createServer(listen);
		server.on('error', errorHandler);
		Node.process.nextTick(function() server.listen(port, host, createHandler));
		storage = new ServersideStorage();

		if (spdyConf == null) return;
		trace(spdyConf);
		final options = { key: Fs.readFileSync('${Node.__dirname}/keys/spdy-key.pem'), cert: Fs.readFileSync(
			'${Node.__dirname}/keys/spdy-cert.pem'
		), ca: Fs.readFileSync('${Node.__dirname}/keys/spdy-csr.pem') };

		spdyServer = spdy.createServer(options, listen).listen(spdyConf.hasField('port') ? spdyConf.port : 443, createSpdyHandler);
	}

	private static inline function get_spdy(): Dynamic return Node.require('spdy');

	public dynamic function onOpen(): Void {}

	public dynamic function onError(): Void {}

	public dynamic function request(connection: IHttpConnection): Void {
		connection.sendText('Welcome from Pony Http Server');
	}

	public function close(?cb: Void -> Void): Void {
		Node.process.nextTick(cb); // How detect closed server???
		server.removeAllListeners();
		server.close();
		server.unref();
		server = null;
		if (spdyServer != null) {
			spdyServer.close();
			spdyServer = null;
		}
		storage = null;
	}

	private function listen(req: IncomingMessage, res: ServerResponse): Void {
		// trace(req.method+': ' + req.url);
		// trace(req.headers);
		for (k => value in fixedHeaders) res.setHeader(k, value);
		final multi: String = 'multipart/form-data';
		final contentType: String = req.headers.field('content-type');
		switch (req.method) {
			case 'POST' if (contentType.length >= multi.length && contentType.substr(0, multi.length) == multi):
				final me = this;
				final multiparty = Type.createInstance(multipartyForm(), []);
				multiparty.parse(req, function(err, fields: Dynamic<Array<Dynamic>>, files: Dynamic<Array<Dynamic>>) {
					if (fields == null || files == null) {
						res.end('error');
					} else {
						final host = if (req.headers.exists('host')) {
							req.headers.get('host');
						} else {
							final a: Dynamic = untyped me.server.address();
							a.address + ':' + a.port;
						}
						final map: Map<String, String> = [];
						for (k in fields.fields()) {
							map[k] = fields.field(k)[0];
						}
						for (k in files.fields()) {
							final f: Dynamic = files.field(k)[0];
							if (f.size > 0) map[k] = f.headers.field('content-type') + ':' + f.path;
						}
						me.request(new HttpConnection('http://' + host + req.url, me.storage, req, res, map));
					}
				});

				return;

			case 'POST':
				final me = this;
				var s: String = '';
				untyped req.addListener('data', function(d: String): Void {
					s += d;
				});
				untyped req.addListener('end', function(Void): Void {
					final h = new Map<String, String>();
					final o: Dynamic = querystring.parse(s);
					for (f in o.fields()) h.set(f, o.field(f));

					final host = if (req.headers.host != null) {
						req.headers.host;
					} else {
						final a: Dynamic = untyped me.server.address();
						a.address + ':' + a.port;
					}
					me.request(new HttpConnection('http://' + host + req.url, me.storage, req, res, h));
				});
				return;

			case 'GET':
				final host = if (req.headers.exists('host')) {
					req.headers.get('host');
				} else {
					final a: Dynamic = untyped server.address();
					a.address + ':' + a.port;
				}
				request(new HttpConnection('http://' + host + req.url, storage, req, res, new Map<String, String>()));
			case 'OPTIONS':
				res.setHeader('Allow', 'POST, GET');
				res.end();
			case 'DELETE', 'PUT':
				res.statusCode = 405;
				res.end();
			case _:
				res.statusCode = 501;
				res.end();
		}
	}

	private function createHandler(): Void {
		if (verbose) {
			final a: Dynamic = untyped server.address();
			trace('HTTP Server running at http://' + a.address + ':' + a.port);
		}
		onOpen();
	}

	private function createSpdyHandler(): Void {
		final a: Dynamic = untyped spdyServer.address();
		trace('SPDY Server running at http://' + a.address + ':' + a.port);
		onOpen();
	}

	private function errorHandler(): Void onError();

	private static function multipartyForm(): Class<Dynamic> {
		if (multipartyClass == null) multipartyClass = Node.require('multiparty').Form;
		return multipartyClass;
	}

}
