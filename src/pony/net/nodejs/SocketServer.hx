package pony.net.nodejs;

#if nodejs
import js.node.Net;
import js.node.net.Server;
import js.node.net.Socket;
import pony.net.SocketServerBase;
import pony.net.SocketClient;

/**
 * SocketServer
 * @author AxGord <axgord@gmail.com>
 */
class SocketServer extends SocketServerBase {

	private var server: Server;

	public function new(port: Int) {
		super();
		server = Net.createServer(null, null);
		server.on('connection', connectionHandler);
		server.listen(port, eOpen.dispatch.bind(false));
	}

	private function connectionHandler(c: Socket): Void {
		var cl: SocketClient = addClient();
		cl.nodejsInit(c);
		@:privateAccess cl.connect();
	}

	override public function destroy(): Void {
		super.destroy();
		server.close(null);
		server = null;
	}

}
#end