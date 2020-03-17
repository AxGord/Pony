package module.server;

import pony.net.http.IHttpConnection;
import pony.net.http.platform.nodejs.HttpServer;
import pony.Logable;

/**
 * Http Server submodule
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Http extends Logable {

	private var server: HttpServer;
	private var path: String;

	public function new(port: UInt, path: String) {
		super();
		this.path = path;
		server = new HttpServer(port);
		server.fixedHeaders['Access-Control-Allow-Origin'] = '*';
		server.request = connectHandler;
	}

	private function connectHandler(connection: IHttpConnection): Void {
		log('Http get: ' + connection.url);
		connection.sendFileOrIndexHtml(path + connection.url);
	}

}