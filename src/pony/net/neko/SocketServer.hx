package pony.net.neko;

#if neko
import sys.net.Socket;
import sys.net.Host;
import haxe.io.Error;
import haxe.io.Eof;
import pony.time.DeltaTime;

/**
 * SocketServer
 * @author AxGord <axgord@gmail.com>
 */
class SocketServer extends pony.net.SocketServerBase {

	private var server: Socket = new Socket();

	public function new(port: Int) {
		super();
		server.bind(new Host('127.0.0.1'), port);
		server.listen(1000);
		server.setBlocking(false);
		DeltaTime.fixedUpdate << waitNewConnection;
	}

	private function waitNewConnection(): Void {
		try {
			var client: Socket = server.accept();
			var cl:SocketClient = cast addClient();
			cl.nekoInit(client);
		} catch (s:String) {
			if (s != 'Blocking') error(s);
		} catch (e:Any) {
			error(e);
		}
	}

	override public function destroy(): Void {
		DeltaTime.fixedUpdate >> waitNewConnection;
		super.destroy();
		server.close();
		server = null;
	}

}
#end