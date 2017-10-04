#if nodejs
import sys.io.File;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;
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

	static function main() {
		var xml = Utils.getXml();
		if (xml.hasNode.server) {
			var sx = xml.node.server;
			path = sx.node.path.innerData;
			var port:Int = Std.parseInt(sx.node.port.innerData);
			var server:HttpServer = new HttpServer(port);
			server.request = connectHandler;

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
		}
	}

	static function connectHandler(connection:IHttpConnection):Void {
		var f = path + connection.url;
		if (FileSystem.exists(f)) {
			if (FileSystem.isDirectory(f)) {
				if (FileSystem.exists(f+'index.htm'))
					connection.sendFile(f+'index.htm');
				else if (FileSystem.exists(f+'index.html'))
					connection.sendFile(f+'index.html');
				else
					connection.error('Not found');
			} else {
				connection.sendFile(f);
			}
		} else {
			connection.error('Not found');
		}
	}

}
#end