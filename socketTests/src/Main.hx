package ;
import haxe.CallStack;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Log;
import haxe.Timer;
import pony.tests.AsyncTests;
import pony.net.SocketClient;
import pony.net.SocketServer;
import pony.Tools;

using pony.Tools;

/**
 * Main
 * @author AxGord <axgord@gmail.com>
 */
 
class Main {
	
	static var testCount:Int = 400;
	#if cs
	static var delay:Int = 3;
	#elseif nodejs
	static var delay:Int = 1;
	#end
	static var port:Int = 16003;
	
	static var partCount:Int = Std.int(testCount/4);
	static var blockCount:Int = Std.int(testCount/2);
	
	static var finish:Bool = false;
	
	static function main() {		
		#if (nodejs && debug)
		js.Node.require('source-map-support').install();
		#end
			trace('Zero part');
			var serv:SocketServer = null;
			var cl = new SocketClient(13579, 100);
			
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
			
			Timer.delay(function() serv = new SocketServer(13579), 100);
			
		#if cs
			while (!finish) Sys.sleep(2);
			AsyncTests.finish();
		#end
	}
	
	static function firstTest():Void {
		trace('First part');
		var server = createServer(6001);
		for (i in 0...partCount) Timer.delay(createClient.bind(i), delay+delay*i);
		
		AsyncTests.wait(0...blockCount, function() {
			trace('Second part');
			server.destroy();
			
			var server = createServer(6002);
			for (i in blockCount...blockCount+partCount) Timer.delay(createClient.bind(i), delay+delay*(i-blockCount));
		
			AsyncTests.wait(blockCount...testCount, function() { 
				server.destroy();
				finish = true;
			} );
		});
		
	}
	
	static function createServer(aPort:Int):SocketServer {
		port = aPort;
		var server = new SocketServer(aPort);
		
		server.onConnect << function(cl:SocketClient):Void {
			cl.sendString('hi world');
		}
		
		server.onData << function(bi:BytesInput):Void {
			var i = bi.readInt32();
			AsyncTests.equals('hello user', bi.readStr());
			AsyncTests.setFlag(partCount + i);
		}
		
		return server;
	}
	
	static function createClient(i:Int):SocketClient {
		var client = new SocketClient(port);
		client.onString < function(s:String) {
			AsyncTests.equals(s, 'hi world');
			var bo = new BytesOutput();
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