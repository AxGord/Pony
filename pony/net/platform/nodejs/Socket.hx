package pony.net.platform.nodejs;

import js.Node;
import pony.net.SocketBase;
import pony.net.SocketUnit;

/**
 * ...
 * @author AxGord
 */

class Socket extends SocketBase
{
	private var server:NodeNetServer;
	
	override private function bind(port:Int):Void {
		if (active) {
			servClose();
			server = null;
		}
		if (server == null) {
			server = Node.net.createServer(listener);
			server.on('error', bindFail);
			server.on('close', onClose);
			server.on('listening', binded);
		}
		server.listen(port, 'localhost');
	}
	
	private function listener(s:NodeNetSocket):Void {
		createSocket(s);
	}
	
	override private function servClose():Void {
		if (server != null)
			server.close(null);
	}
	
	override private function _connect(host:String, port:Int):Void {
		var s:NodeNetSocket = Node.net.createConnection(port, host);
		s.on('error', sockError);
		s.on('connect', function() {
			if (enabled)
				createSocket(s);
			else {
				s.end();
				s.destroy();
			}
		});
	}
	
	private function createSocket(o:NodeNetSocket):Void {
		new SocketUnit(sockets.length, this, o);
	}
	
}