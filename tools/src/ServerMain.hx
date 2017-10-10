#if nodejs
import sys.io.File;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;
import js.node.ChildProcess;
import js.node.http.IncomingMessage;
import js.node.http.ServerResponse;
import pony.net.http.HttpServer;
import pony.net.http.IHttpConnection;
import sys.FileSystem;

/**
 * ServerMain
 * @author AxGord <axgord@gmail.com>
 */
class ServerMain {

	static var path:String;
	static var haxePort:String;

	static function main() {
		var xml = Utils.getXml();
		if (xml.hasNode.server) {
			var sx = xml.node.server;

			if (sx.hasNode.port && sx.hasNode.path) {
				path = sx.node.path.innerData;
				var port:Int = Std.parseInt(sx.node.port.innerData);
				var server:HttpServer = new HttpServer(port);
				server.request = connectHandler;
			}

			if (sx.hasNode.proxy) {
				var px = sx.node.proxy;
				var target = px.node.target.innerData;
				var port = px.node.port.innerData;
				Node.require('http-proxy')
				.createProxyServer({
					target: target,
					headers: {'Host': '127.0.0.1:$port'}
				})
				.listen(Std.parseInt(port));
			}

			if (sx.hasNode.haxe) {
				haxePort = sx.node.haxe.innerData;
				runHaxeServer();
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
		connection.sendFileOrIndexHtml(path + connection.url);
	}

}
#end