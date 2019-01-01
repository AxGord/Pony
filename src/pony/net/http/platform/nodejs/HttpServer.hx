package pony.net.http.platform.nodejs;

import js.Node;
import js.node.Fs;
import js.node.Http;
import js.node.http.IncomingMessage;
import js.node.http.Server;
import js.node.http.ServerResponse;
import pony.Pair;
import pony.net.http.IHttpConnection;
import pony.net.http.ServersideStorage;

using Reflect;

/**
 * HttpServer
 * @author AxGord <axgord@gmail.com>
 */
class HttpServer {
	
	public static var multipartyClass:Class<Dynamic> = Node.require('multiparty').Form;
	public static var querystring:Dynamic = Node.require('querystring');
	
	private static var spdy(get, never):Dynamic;

	private var server:Server;
	private var spdyServer:Dynamic;
	public var storage:ServersideStorage;
	public var fixedHeaders:Map<String, String> = ['Server' => 'PonyHttpServer'];
	
	inline private static function get_spdy():Dynamic return Node.require('spdy');
	
	public function new(host:String = null, port:Int = 80, ?spdyConf:Dynamic)
	{
		server = Http.createServer(listen);
		server.on('error', errorHandler);
		Node.process.nextTick(function() server.listen(port, host, createHandler));
		storage = new ServersideStorage();
		
		if (spdyConf != null) {
			trace(spdyConf);
			var options = {
				key: Fs.readFileSync(Node.__dirname + '/keys/spdy-key.pem'),
				cert: Fs.readFileSync(Node.__dirname + '/keys/spdy-cert.pem'),
				ca: Fs.readFileSync(Node.__dirname + '/keys/spdy-csr.pem')
			};
			
			spdyServer = spdy.createServer(options, listen).listen(spdyConf.hasField('port') ? spdyConf.port : 443, createSpdyHandler);
		}
	}
	
	private function listen(req:IncomingMessage, res:ServerResponse):Void {
		//trace(req.method+': ' + req.url);
		//trace(req.headers);
		for (k in fixedHeaders.keys()) res.setHeader(k, fixedHeaders[k]);
		var multi = 'multipart/form-data';
		switch (req.method/*.toUpperCase()*/) {
			case 'POST' if ((req.headers.field('content-type'):String).substr(0, multi.length) == multi):
				var me = this;
				var multiparty = Type.createInstance(multipartyClass, []);
				multiparty.parse(req, function(err, fields:Dynamic<Array<Dynamic>>, files:Dynamic<Array<Dynamic>>) {
					if (fields == null || files == null) {
						res.end('error');
					} else {
						var host = if (req.headers.exists('host')) {
							req.headers.get('host');
						} else {
							var a:Dynamic = untyped me.server.address();
							a.address + ':' + a.port;
						}
						var map:Map<String, String> = new Map();
						for (k in fields.fields()) {
							map[k] = fields.field(k)[0];
						}
						for (k in files.fields()) {
							var f:Dynamic = files.field(k)[0];
							if (f.size > 0) map[k] = f.headers.field('content-type')+':'+f.path;
						}
						me.request(new HttpConnection('http://' + host + req.url, me.storage, req, res, map));
					}
				});
				
				return;
			
			case 'POST':
				var me = this;
				var s:String = '';
				untyped req.addListener('data', function(d:String):Void {
					s += d;
				});
				untyped req.addListener('end', function(Void):Void {
					var h = new Map<String, String>();
					var o:Dynamic = querystring.parse(s);
					for (f in o.fields())
						h.set(f, o.field(f));
					
					var host = if (req.headers.host != null) {
						req.headers.host;
					} else {
						var a:Dynamic = untyped me.server.address();
						a.address + ':' + a.port;
					}
					me.request(new HttpConnection('http://' + host + req.url, me.storage, req, res, h));
				});
				return;
				
			case 'GET':
				var host = if (req.headers.exists('host')) {
					req.headers.get('host');
				} else {
					var a:Dynamic = untyped this.server.address();
					a.address + ':' + a.port;
				}
				request(new HttpConnection('http://' + host + req.url, storage, req, res, new Map<String, String>()));
			case 'OPTIONS':
				res.setHeader('Allow', 'POST, GET');
				res.end();
			case 'DELETE', 'PUT':
				res.statusCode = 405;
				res.end();
			default:
				res.statusCode = 501;
				res.end();
		}
	}

	public dynamic function onOpen():Void {}
	public dynamic function onError():Void {}
	
	private function createHandler():Void {
		var a:Dynamic = untyped server.address();
		trace('HTTP Server running at http://' + a.address + ':' + a.port);
		onOpen();
	}
	
	private function createSpdyHandler():Void {
		var a:Dynamic = untyped spdyServer.address();
		trace('SPDY Server running at http://' + a.address + ':' + a.port);
		onOpen();
	}

	private function errorHandler():Void onError();
	
	public dynamic function request(connection:IHttpConnection):Void {
		connection.sendText('Welcome from Pony Http Server');
	}

	public function close(?cb:Void -> Void):Void {
		Node.process.nextTick(cb); //How detect closed server???
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
	
}