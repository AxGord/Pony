import js.node.Buffer;
import js.node.Fs;
#if nodejs
import sys.io.File;
import sys.FileSystem;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;
import js.node.ChildProcess;
import js.node.http.IncomingMessage;
import js.node.http.ServerResponse;
import pony.net.http.HttpServer;
import pony.net.http.IHttpConnection;
import pony.NPM;
import sys.FileSystem;
import remote.server.ServerRemote;

/**
 * ServerMain
 * @author AxGord <axgord@gmail.com>
 */
class ServerMain {

	static var path:String;
	static var haxePort:String;

	static function main() {
		NPM.source_map_support.install();
		var xml = Utils.getXml();
		if (xml.hasNode.server) {
			var sx = xml.node.server;

			if (sx.hasNode.port && sx.hasNode.path) {
				path = sx.node.path.innerData;
				var port:Int = Std.parseInt(sx.node.port.innerData);
				var server:HttpServer = new HttpServer(port);
				server.fixedHeaders['Access-Control-Allow-Origin'] = '*';
				server.request = connectHandler;
			}

			if (sx.hasNode.proxy) {
				for (px in sx.nodes.proxy) {
					var target = px.node.target.innerData;
					var port = px.node.port.innerData;
					var locport:Int = Std.parseInt(sx.node.port.innerData);
					trace('Start proxy server on $port to $target target');
					if (!px.has.slow && !px.has.cache) {
						NPM.http_proxy.createProxyServer({
							target: target,
							headers: {'Host': '127.0.0.1:$port'}
						}).on('error', function (err, req, res) {
							res.writeHead(500, {
								'Content-Type': 'text/plain'
							});
							res.end('Something went wrong.');
						}).listen(Std.parseInt(port));
					} else {
						var proxy:Dynamic = NPM.http_proxy.createProxyServer();
						var path:String = px.has.cache ? StringTools.trim(px.att.cache) : null;
						var requested:Array<String> = [];
						if (px.has.cache)
							proxy.on('proxyRes', function (proxyRes:IncomingMessage, req:IncomingMessage, res:ServerResponse) {
								var rpath:String = path + req.url;
								rpath = StringTools.replace(rpath, '//', '/').split('?')[0];
								if (!FileSystem.exists(rpath) && requested.indexOf(rpath) == -1) {
									Utils.createPath(rpath);
									requested.push(rpath);
									var file:js.node.fs.WriteStream = Fs.createWriteStream(rpath);
									proxyRes.pipe(file);
								}
							});

						js.node.Http.createServer(function(req:IncomingMessage, res:ServerResponse) {
							var url = target; // + req.url;
							if (px.has.slow) {
								trace('Slow proxy request: ' + url);
								Node.setTimeout(function () {
									proxy.web(req, res, {
										target: url,
										changeOrigin: true
									});
								}, Std.parseInt(px.att.slow));
							} else if (px.has.cache) {
								trace('Proxy request: ' + req.url);
								var rpath:String = path + req.url;
								rpath = StringTools.replace(rpath, '//', '/').split('?')[0];
								trace('get: $rpath');
								if (FileSystem.exists(rpath)) {
									if (sx.hasNode.path && path == sx.node.path.innerData) {
										trace('http://127.0.0.1:$locport' + req.url);
										proxy.web(req, res, cast {
											target: 'http://127.0.0.1:$locport',
											changeOrigin: true
										});
									} else {
										throw 'sorry';
									}
								} else {
									trace('selfHandleResponse: ' + url);
									req.headers.remove('accept-encoding');
									proxy.web(req, res, cast {
										target: url,
										changeOrigin: true
									});
								}
							} else {
								throw 'error';
							}
						}).listen(port);
					}
				}
			}

			if (sx.hasNode.haxe) {
				haxePort = sx.node.haxe.innerData;
				runHaxeServer();
			}

			if (sx.hasNode.remote) {
				new ServerRemote(sx.node.remote);
			}

		}
	}

	static function runHaxeServer():Void {
		var r = 'haxe -v --wait $haxePort';
		Sys.println(r);
		var p = ChildProcess.exec(r, execHandler);
		p.stdout.on('data', traceData);
		p.stderr.on('data', traceData);
		p.on('exit', childExitHandler);
	}

	static function execHandler(err:Null<ChildProcessExecError>, a1:String, a2:String):Void {
		Sys.println('haxe server is exec');
		runHaxeServer();
	}

	static function childExitHandler(code:Int):Void {
		Sys.println('Child exited with code $code');
	}

	static function traceData(data):Void {
		Sys.print(data);
	}

	static function connectHandler(connection:IHttpConnection):Void {
		Sys.println('Http get: ' + connection.url);
		connection.sendFileOrIndexHtml(path + connection.url);
	}

}
#end