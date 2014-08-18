package ;
import haxe.CallStack;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Log;
import haxe.Timer;
import pony.AsyncTests;
import pony.net.SocketClient;
import pony.net.SocketServer;
import pony.Tools;

using pony.Tools;

/**
 * Main
 * @author AxGord <axgord@gmail.com>
 */
 
class Main {
	
	
	static var testCount:Int = 20;
	#if cs
	static var delay:Int = 300;
	#elseif nodejs
	static var delay:Int = 5;
	#end
	static var port:Int = 16001;
	
	static var partCount:Int = Std.int(testCount/4);
	static var blockCount:Int = Std.int(testCount/2);
	
	static function main() {		
		#if (nodejs && debug)
		js.Node.require('source-map-support').install();
		#end
		#if cs
		try {
		#end
		
			if (testCount % 4 != 0) throw 'Wrong test count';
			AsyncTests.init(testCount);
			firstTest();
			
			/*
			var s = new SocketServer(port);
			s.onConnect < function() trace('new client');
			var c = new SocketClient(port);
			c.connected.wait(function() trace('connected'));*/
			
		#if cs
			Sys.getChar(false);
			AsyncTests.finish();
		} catch (e:String) Tools.traceThrow(e);
		#end
	}
	
	static function firstTest():Void {
		var server = createServer();
		
		for (i in 0...partCount) Timer.delay(createClient.bind(i), delay+delay*i);
		
		AsyncTests.wait(0...blockCount, function() {
			trace('Second part');
			server.destroy();
			var server = createServer();
			for (i in blockCount...blockCount+partCount) Timer.delay(createClient.bind(i), delay+delay*(i-blockCount));
		});
		
	}
	
	static function createServer():SocketServer {
		var server = new SocketServer(port);
		
		server.onConnect << function(cl:SocketClient):Void {
			var bo = new BytesOutput();
			bo.writeStr('hi world');
			//trace(bo.length);
			cl.send(bo);
		};
		
		server.onData << function(bi:BytesInput):Void {
			var i = bi.readInt32();
			AsyncTests.equals('hello user', bi.readStr());
			AsyncTests.setFlag(partCount + i);
		};
		
		return server;
	}
	
	static function createClient(i:Int):SocketClient {
		var client = new SocketClient(port);
			
		client.onData < function(data:BytesInput):Void {
			var s = data.readStr();
			AsyncTests.equals(s, 'hi world');
			var bo = new BytesOutput();
			bo.writeInt32(i);
			bo.writeStr('hello user');
			client.send(bo);
			AsyncTests.setFlag(i);
			Sys.sleep(500);
			client.destroy();
		};
		
		return client;
	}
	
}