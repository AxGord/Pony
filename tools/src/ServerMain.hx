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
		var xml = Utils.getXml().node.server;
		path = xml.node.path.innerData;
		var port:Int = Std.parseInt(xml.node.port.innerData);
		var server:HttpServer = new HttpServer(port);
		server.request = connectHandler;
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