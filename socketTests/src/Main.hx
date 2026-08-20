package;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Log;
import haxe.Timer;
import pony.net.ISocketClient;
import pony.net.SocketClient;
import pony.net.SocketServer;
import pony.tests.AsyncTests;

using pony.Tools;

/**
 * Main
 * @author AxGord <axgord@gmail.com>
 */

class Main {

	private static inline final testCount: Int = 400;

	#if cs
	private static inline final delay: Int = 3;
	#elseif nodejs
	private static inline final delay: Int = 1;
	#end

	private static var port: Int = 16003;

	private static final partCount: Int = Std.int(testCount / 4);
	private static final blockCount: Int = Std.int(testCount / 2);

	private static var finish: Bool = false;

	private static function main(): Void {
		#if (nodejs && debug)
		js.Node.require('source-map-support').install();
		#end
		trace('Zero part');
		var serv: SocketServer = null;
		final cl: SocketClient = new SocketClient(13579, 100);

		cl.onLog << Log.trace;
		cl.onError << Log.trace;
		cl.onConnect << function() {
			trace('Connected');
			cl.destroy();
			serv.destroy();
			if (testCount % 4 != 0) throw 'Wrong test count';
			AsyncTests.init(testCount);
			firstTest();

		}

		Timer.delay(() -> serv = new SocketServer(13579), 100);

		#if cs
		while (!finish) Sys.sleep(2);
		AsyncTests.finish();
		#end
	}

	private static function firstTest(): Void {
		trace('First part');
		final server: SocketServer = createServer(6001);
		for (i in 0...partCount) Timer.delay(createClient.bind(i), delay + delay * i);

		AsyncTests.wait(0...blockCount, () -> {
			trace('Second part');
			server.destroy();

			final server: SocketServer = createServer(6002);
			for (i in blockCount ... blockCount + partCount) Timer.delay(createClient.bind(i), delay + delay * (i - blockCount));

			AsyncTests.wait(blockCount ... testCount, () -> {
				server.destroy();
				finish = true;
			});
		});

	}

	private static function createServer(aPort: Int): SocketServer {
		port = aPort;
		final server: SocketServer = new SocketServer(aPort);

		server.onConnect << function(cl: ISocketClient): Void {
			cl.sendString('hi world');
		}

		server.onData << function(bi: BytesInput): Void {
			final i: Int = bi.readInt32();
			AsyncTests.equals('hello user', bi.readStr());
			AsyncTests.setFlag(partCount + i);
		}

		return server;
	}

	private static function createClient(i: Int): SocketClient {
		var client: SocketClient = new SocketClient(port);
		client.onString < function(s: String) {
			AsyncTests.equals(s, 'hi world');
			final bo: BytesOutput = new BytesOutput();
			bo.writeInt32(i);
			bo.writeStr('hello user');
			client.send(bo);
			AsyncTests.setFlag(i);
			client.destroy();
			client = null;
		}
		return client;
	}

}
