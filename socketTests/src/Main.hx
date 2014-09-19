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
	
	
	static var testCount:Int = 500;
	#if cs
	static var delay:Int = 30;
	#elseif nodejs
	static var delay:Int = 1;
	#end
	static var port:Int = 16001;
	
	static var partCount:Int = Std.int(testCount/4);
	static var blockCount:Int = Std.int(testCount/2);
	
	static function main() {		
		#if (nodejs && debug)
		js.Node.require('source-map-support').install();
		#end
		#if cs
		trace('Please, not touch keyboard :)');
		try {
		#end
			/*var s = new SocketServer(port);
			s.onConnect < function() trace('new client');
			var c = new SocketClient("127.0.0.1", port, 1);
			s.onData << function(b_in:BytesInput)
			{
				trace(b_in.readDouble());
			}
			c.connected.wait(function() 
			{
				trace('connected');
				var b_out:BytesOutput = new BytesOutput();
				b_out.writeDouble(34.34);
				c.send(b_out);
			});*/
			trace('try connect');
			var serv:SocketServer = null;
			var cl = new SocketClient(13579, 100);
			cl.connected.wait(function() {
				
				
				//todo: Not work!
				//serv.destroy();
				//cl.destroy();
				
				trace('ok');
				
				if (testCount % 4 != 0) throw 'Wrong test count';
				AsyncTests.init(testCount);
				firstTest();
				
			});
			
			Timer.delay(function() serv = new SocketServer(13579), 3000);
			
		#if cs
			Sys.getChar(false); 
			AsyncTests.finish();
			//Sys.exit(0);
		} catch (e:String) Tools.traceThrow(e);
		#end
		//todo: NodeJS not exit!
	}
	
	static function firstTest():Void {
		var server = createServer(6001);
		
		for (i in 0...partCount) Timer.delay(createClient.bind(i), delay+delay*i);
		
		AsyncTests.wait(0...blockCount, function() {
			trace('Second part');
			server.destroy();
			var server = createServer(6002);
			for (i in blockCount...blockCount+partCount) Timer.delay(createClient.bind(i), delay+delay*(i-blockCount));
		});
		
	}
	
	static function createServer(aPort:Int):SocketServer {
		port = aPort;
		var server = new SocketServer(aPort);
		
		server.onConnect << function(cl:SocketClient):Void {
			var bo = new BytesOutput();
			//bo.writeDouble(23.23);
			var s:String = "hi world";
			bo.writeStr(s);
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
			if (s == null) throw 'wrong data';
			AsyncTests.equals(s, 'hi world');
			var bo = new BytesOutput();
			bo.writeInt32(i);
			bo.writeStr('hello user');
			client.send(bo);
			AsyncTests.setFlag(i);
			//Sys.sleep(1000);
			client.destroy();
		};
		
		return client;
	}
	
}