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

class SocketServer extends SocketServerBase
{

	private var server:Socket;
	private var port:Int;
	private var eventAccept:ManualResetEvent = new ManualResetEvent(false);
	private var eventReceive:ManualResetEvent = new ManualResetEvent(false);
	private var isRunning:Bool;
	
	public override function new(aPort:Int) 
	{
		super();
		port = aPort;
		var ep:IPEndPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), port);
		server = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
		server.Bind(ep);
		server.Listen(100);
		isRunning = true;
		for (i in 0...10) 
		{
			server.BeginAccept(new AsyncCallback(acceptCallback), server);
		}
	}
	
	private function acceptCallback(ar:IAsyncResult):Void
	{
		if (isRunning)
		{
			eventAccept.Reset();
			//trace("Client accepted.");
			var s:Socket = cast(ar.AsyncState, Socket);
			var cl:SocketClient = clInit();
			cl.client = s.EndAccept(ar);
			Monitor.Enter(clients);
			try 
			{
				clients.push(cl);
			}
			catch (ex:Dynamic)
			{
				Monitor.Exit(clients);
			}
			Monitor.Exit(clients);
			try
			{
				cl.receiveBuffer = new NativeArray(4);
				cl.isSet = false;
				cl.client.BeginReceive(cl.receiveBuffer, 0, cl.receiveBuffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), cl);
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
	
	private function receiveCallback(ar:IAsyncResult):Void
	{
		if (isRunning)
		{
			eventReceive.Reset();
			var cl:SocketClient = cast(ar.AsyncState, SocketClient);
			try
			{
				var bytesRead:Int = cl.client.EndReceive(ar);
				if (0 != bytesRead)
				{
					var receiveBuffer:NativeArray<UInt8> = cl.receiveBuffer;
					var b_out:BytesOutput = new BytesOutput();
					for (i in 0...bytesRead)
					{
						b_out.writeByte(receiveBuffer[i]);
					}
					var b_in:BytesInput = new BytesInput(b_out.getBytes());
					if (cl.isSet) 
					{					
						onData.dispatch(b_in);
						var buffer:NativeArray<UInt8> = new NativeArray(4);
						cl.receiveBuffer = buffer;
						cl.isSet = false;
						cl.client.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), cl);
					}
					else
					{
						var buffer:NativeArray<UInt8>;
						if (isWithLength)
						{
							var size:Int = b_in.readInt32();
							buffer = new NativeArray(size);
						}
						else
						{
							buffer = new NativeArray(255);
						}
						cl.receiveBuffer = buffer;
						cl.isSet = true;
						cl.client.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), cl); //BeginReceive has to be called every time callback is, not when isSet is false only. Fixed.
					}
				}
				else
				{
					closeConnection(cl);
				}
			}
			catch (ex:Dynamic)
			{
				closeConnection(cl);
				trace(ex);
			}
		}
		eventReceive.Set();
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
			Monitor.Exit(clients);
		}
		Monitor.Exit(clients);
	}
	
	private function clInit():SocketClient
	{
		var cl:SocketClient = Type.createEmptyInstance(SocketClient);
		cl.init(cast this, clients.length);
		cl.isWithLength = this.isWithLength;
		cl.sendQueue = new Queue(cl._send);
		cl.isRunning = true;
		cl.eventReceive = new ManualResetEvent(false);
		cl.eventSend = new ManualResetEvent(false);
		return cl;
	}
	
	public override function destroy():Void
	{
		//Sys.sleep(1);
		isRunning = false;
		eventReceive.WaitOne(500);
		eventAccept.WaitOne(500);	//The events DO guarantee that executing callbacks finish correct and DO NOT guarantee that next callbacks will execute so it may cause a loss of data;
		server.Close();			//to prevent this situation there is a Sys.sleep(1) that makes main thread to wait for other threads to finish its executing. 
		super.destroy();
	}
}