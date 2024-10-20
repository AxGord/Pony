package ;

import pony.net.ISocketClient;
import haxe.io.BytesOutput;
import js.Node;
import pony.net.SocketClient;
import pony.net.SocketServer;

using pony.Tools;

/**
 * Main
 * @author AxGord
 */

class Main {

	static function main() {
		var s = new SocketServer(13579);
		s.onConnect << function(cl:ISocketClient):Void {
			var bo = new BytesOutput();
			bo.writeStr('Hello man!');
			cl.send(bo);
		}
	}

}