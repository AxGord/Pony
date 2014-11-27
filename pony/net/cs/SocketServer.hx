package pony.net.cs;

/**
 * SocketServer
 * @author DIS
 */

 import cs.NativeArray.NativeArray;
 import cs.system.IAsyncResult;
 import cs.system.AsyncCallback;
 import cs.system.net.sockets.Socket;
 import cs.system.net.IPEndPoint;
 import cs.system.net.IPAddress;
 import cs.system.net.sockets.SocketFlags;
 import cs.system.net.sockets.SocketException;
 import cs.system.net.sockets.AddressFamily;
 import cs.system.net.sockets.SocketType;
 import cs.system.net.sockets.ProtocolType;
 import cs.system.threading.ManualResetEvent;
 import cs.system.threading.Monitor;
 import cs.types.UInt8;
 import haxe.io.Bytes;
 import haxe.io.BytesInput;
 import haxe.io.BytesOutput;
 import pony.events.Signal;
 import pony.events.Signal1.Signal1;
 import pony.net.SocketServerBase;
 import pony.net.SocketClient;
 import pony.Queue.Queue;
 import cs.system.threading.Interlocked;

class SocketServer extends SocketServerBase
{

	private var server:Socket;
	private var port:Int;
	private var eventAccept:ManualResetEvent = new ManualResetEvent(true);
	private var eventReceive:ManualResetEvent = new ManualResetEvent(true);
	private var isRunning:Bool;
	
	public override function new(aPort:Int) 
	{
		super();
		port = aPort;
		var ep:IPEndPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), port);
		server = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
		server.NoDelay = true;
		server.Bind(ep);
		server.Listen(1000);
		isRunning = true;
		for (i in 0...1) 
		{
			server.BeginAccept(new AsyncCallback(acceptCallback), server);
		}
	}
	
	private function acceptCallback(ar:IAsyncResult):Void
	{
		if (isRunning)
		{
			eventAccept.Reset();
			var s:Socket = cast(ar.AsyncState, Socket);
			var cl:SocketClient = clInit();
			cl.client = s.EndAccept(ar);
			cl.client.NoDelay = true; //One should never forget that this may cause troubles in future.
			Monitor.Enter(clients);
			try 
			{
				clients.push(cl);
			}
			catch (ex:Dynamic)
			{
				Monitor.PulseAll(clients);
				Monitor.Exit(clients);
			}
			Monitor.PulseAll(clients);
			Monitor.Exit(clients);
			try
			{
				cl.receiveBuffer = new NativeArray(255);
				cl.isSet = false;
				cl.client.BeginReceive(cl.receiveBuffer, 0, cl.receiveBuffer.Length, SocketFlags.None, new AsyncCallback(cl.receiveCallback), cl);
				onConnect.dispatch(cl);
				s.BeginAccept(new AsyncCallback(acceptCallback), ar.AsyncState);	
			}
			catch (ex:SocketException)
			{
				closeConnection(cl);
				trace(ex);
			}
		}
		eventAccept.Set();
	}
	
	private function closeConnection(cl:SocketClient):Void
	{
		cl.client.Close();
		Monitor.Enter(clients);
		try
		{
			clients.remove(cl);
		}
		catch (ex:Dynamic)
		{
			Monitor.PulseAll(clients);
			Monitor.Exit(clients);
		}
		Monitor.PulseAll(clients);
		Monitor.Exit(clients);
	}
	
	private function clInit():SocketClient
	{
		var cl:SocketClient = Type.createEmptyInstance(SocketClient);
		Monitor.Enter(clients);
		try 
		{
			cl.init(cast this, clients.length);
		}
		catch (_:Dynamic)
		{
			Monitor.PulseAll(clients);
			Monitor.Exit(clients);
		}
		Monitor.PulseAll(clients);
		Monitor.Exit(clients);
		cl.isWithLength = this.isWithLength;
		cl.sendQueue = new Queue(cl._send);
		cl.isRunning = true;
		cl.eventReceive = new ManualResetEvent(true);
		cl.eventSend = new ManualResetEvent(true);
		return cl;
	}
	
	public override function destroy():Void
	{
		isRunning = false;
		eventReceive.WaitOne();
		trace("Server's close traced.");
		eventAccept.WaitOne();//The events DO guarantee that executing callbacks finish correct and DO NOT guarantee that next callbacks will execute so it may cause a loss of data;
		server.Close();		  //to prevent this situation there is a Sys.sleep(1) that makes main thread to wait for other threads to finish its executing. There's no more need in the Sys.sleep(1).
		super.destroy();
	}
}