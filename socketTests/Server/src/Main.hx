package;

import haxe.io.BytesOutput;
import js.Node;
import pony.net.ISocketClient;
import pony.net.SocketClient;
import pony.net.SocketServer;

using pony.Tools;

/**
 * Main
 * @author AxGord
 */

class Main {

	private static function main(): Void {
		final s = new SocketServer(13579);
		s.onConnect << function(cl: ISocketClient): Void {
			final bo = new BytesOutput();
			bo.writeStr('Hello man!');
			cl.send(bo);
		}
	}

}
