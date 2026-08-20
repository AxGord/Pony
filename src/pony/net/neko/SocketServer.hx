package pony.net.neko;

#if neko
import haxe.io.Eof;
import haxe.io.Error;
import pony.time.DeltaTime;
import sys.net.Host;
import sys.net.Socket;

/**
 * SocketServer
 * @author AxGord <axgord@gmail.com>
 */
class SocketServer extends pony.net.SocketServerBase {

	private var server: Socket = new Socket();

	public function new(host: String, port: Int) {
		super();
		server.bind(new Host(host), port);
		server.listen(1000);
		server.setBlocking(false);
		DeltaTime.fixedUpdate << waitNewConnection;
	}

	override public function destroy(): Void {
		DeltaTime.fixedUpdate >> waitNewConnection;
		super.destroy();
		server.close();
		server = null;
	}

	private function waitNewConnection(): Void {
		try {
			final client: Socket = server.accept();
			final cl: SocketClient = cast addClient();
			cl.nekoInit(client);
		} catch (s: String) {
			if (s != 'Blocking') error(s);
		} catch (e: Any) {
			error(e);
		}
	}

}
#end
