package pony.net.cs;
#if cs
import haxe.io.Bytes;
import cs.system.net.sockets.Socket;
import cs.system.net.sockets.SocketAsyncEventArgs;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.events.Signal;
import pony.events.Signal0.Signal0;
import pony.events.Signal1.Signal1;
import cs.NativeArray.NativeArray;
import cs.system.net.sockets.Socket;
import cs.system.net.sockets.SocketAsyncEventArgs;
import cs.system.net.sockets.SocketShutdown;
import cs.system.net.sockets.SocketException;
import cs.system.Object;
import cs.system.EventHandler_1;
import cs.types.UInt8;
import pony.net.SocketClientBase;

/**
 * SocketClient
 * A class wrapping an async-based C# client.
 * @author DIS
 **/

class SocketClient extends SocketClientBase
{

	@:allow(pony.net.cs.SocketServer)
	private var socket:Socket;
	@:allow(pony.net.cs.SocketServer)
	private var isFromServer:Bool = false;
	private var client:CSClient;
	
	/**
	 * Creates a new client. Type "127.0.0.1" if you want to use localhost as host. 
	 **/
	public override function new(aHost:String, aPort:Int):Void
	{
		super(aHost, aPort);
		client = new CSClient(host, port);
		client.onConnect < function()
		{
			this.onConnect.dispatch(cast this);
		}
		client.onData << function(b_in:BytesInput)
		{
			//joinData(b_in);
			onData.dispatch(b_in);
		}
	}
	
	/**
	 * Connects client.
	 **/
	public function connect():Void
	{
		client.connect();
	}
	
	/**
	 * Sends a data to a server.
	 **/
	public function send(b_out:BytesOutput):Void
	{
		if (isFromServer)
		{
			BaseSocket.baseSend(socket, b_out);
		}
		else
		{
			client.send(b_out);
		}
	}
	
	public override function destroy():Void
	{
		client.Dispose();
		super.destroy();
		client = null;
	}
}
#end