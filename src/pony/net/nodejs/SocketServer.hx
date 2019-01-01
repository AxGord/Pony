package pony.net.nodejs;

#if nodejs

/**
 * SocketServer
 * @author AxGord <axgord@gmail.com>
 */
class SocketServer extends pony.net.SocketServerBase {

	private var server:js.node.net.Server;
	
	public function new(port:Int) {
		super();
		server = js.node.Net.createServer(null,null);
		server.on('connection', connectionHandler);
		server.listen(port, eOpen.dispatch.bind(false));
	}
	
	private function connectionHandler(c:js.node.net.Socket):Void {
		var cl = addClient();
		cl.nodejsInit(c);
		@:privateAccess cl.connect();
	}
	
	override public function destroy():Void {
		super.destroy();
		server.close(null);
		server = null;
	}
	
}
#end