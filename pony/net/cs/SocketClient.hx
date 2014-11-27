package pony.net.cs;

/**
 * SocketClient
 * @author DIS
 */

 import cs.NativeArray.NativeArray;
 import cs.StdTypes.UInt8;
 import cs.system.net.sockets.SocketInformation;
  import cs.system.net.IPAddress;
 import cs.system.IAsyncResult;
 import cs.system.net.sockets.Socket;
 import cs.system.net.sockets.AddressFamily;
 import cs.system.net.sockets.SocketType;
 import cs.system.net.sockets.ProtocolType;
 import cs.system.net.sockets.SocketFlags;
 import cs.system.net.sockets.SocketException;
 import cs.system.threading.ManualResetEvent;
 import cs.system.threading.Monitor;
 import cs.system.threading.Interlocked;
 import cs.system.AsyncCallback;
 import haxe.io.BytesInput;
 import haxe.io.BytesOutput;
 import pony.net.SocketClientBase;
 import pony.Queue.Queue;
 
class SocketClient extends SocketClientBase
{
	@:allow(pony.net.cs.SocketServer)
	private var client:Socket;
	/**
	 * Indicates if a client sended first or second datagramm; the first one is being sended if isSet is false, true instead.
	 **/
	@:allow(pony.net.cs.SocketServer)
	private var isSet:Bool = false;
	@:allow(pony.net.cs.SocketServer)
	private var receiveBuffer:NativeArray<UInt8> = new NativeArray(255);
	@:allow(pony.net.cs.SocketServer)
	private var sendQueue:Queue < BytesOutput -> Void > ;
	@:allow(pony.net.cs.SocketServer)
	private var eventSend:ManualResetEvent = new ManualResetEvent(true);
	@:allow(pony.net.cs.SocketServer)
	private var eventReceive:ManualResetEvent = new ManualResetEvent(true);
	@:allow(pony.net.cs.SocketServer)
	private var isRunning:Bool;
	private var isConnected:Bool = false;
	
	public override function new(aHost:String = "127.0.0.1", aPort:Int, aReconnect:Int = -1, aIsWithLength:Bool = true) 
	{
		isRunning = true;
		host = aHost;
		port = aPort;
		this.reconnectDelay = aReconnect;
		this.isWithLength = aIsWithLength;
		client = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
		client.NoDelay = true; //One should never forget that this may cause troubles in future.
		super(host, port, reconnectDelay, aIsWithLength);
	}
	
	public override function open():Void
	{
		try
		{
			client.Connect(host, port);
			isConnected = true;
		}
		catch (ex:SocketException)
		{
			isConnected = false;
			reconnect();
		}
		if (isConnected)
		{
			connected.end();
			sendQueue = new Queue(_send);
			isSet = false;
			client.BeginReceive(receiveBuffer, 0, receiveBuffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), this);
		}
	}
	
	public function send(data:BytesOutput):Void
	{
		Monitor.Enter(sendQueue);
		try
		{
			sendQueue.call(data);
		}
		catch (ex:Dynamic)
		{
			Monitor.Exit(sendQueue);
		}
		Monitor.Exit(sendQueue);
	}
	
	@:allow(pony.net.cs.SocketServer)
	private function _send(data:BytesOutput):Void
	{
		var buffer:NativeArray<UInt8> = new NativeArray(data.length);
		var b_out:BytesOutput = new BytesOutput();
		var size:Int = buffer.Length;
		b_out.writeBytes(data.getBytes(), 0, size);
		var b_in:BytesInput = new BytesInput(b_out.getBytes());
		for (i in 0...b_in.length) buffer[i] = b_in.readByte();
		client.BeginSend(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(sendCallback), client);
	}
	
	private function sendCallback(ar:IAsyncResult):Void
	{
		if (isRunning)
		{
			eventSend.Reset();
			var s:Socket = cast(ar.AsyncState, Socket);
			s.EndSend(ar);
			Monitor.Enter(sendQueue);
			try
			{
				sendQueue.next();
			}
			catch (ex:Dynamic)
			{
				Monitor.Exit(sendQueue);
			}
			Monitor.Exit(sendQueue);
		}
		eventSend.Set();
	}
	
	@:allow(pony.net.cs.SocketServer)
	private function receiveCallback(ar:IAsyncResult):Void
	{
		if (isRunning)
		{
			eventReceive.Reset();
			try
			{
				var bytesRead:Int = client.EndReceive(ar);
				if (0 != bytesRead)
				{
					var receiveBuffer:NativeArray<UInt8> = receiveBuffer;
					var b_out:BytesOutput = new BytesOutput();
					for (i in 0...bytesRead)
					{
						b_out.writeByte(receiveBuffer[i]);
					}
					var b_in:BytesInput = new BytesInput(b_out.getBytes());
					if (isSet) 
					{
						eventReceive.Set();
						onData.dispatch(b_in);
						var buffer:NativeArray<UInt8> = new NativeArray(255);
						receiveBuffer = buffer;
						isSet = false;
						client.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), this);
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
						onData.dispatch(b_in);
						receiveBuffer = buffer;
						isSet = true;
						client.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), this);
					}
				}
				else
				{

				}
			}
			catch (ex:Dynamic)
			{
				trace(ex);
			}
		}
		eventReceive.Set();
	}
	
	public override function destroy():Void
	{
		isRunning = false;
		eventReceive.WaitOne();
		eventSend.WaitOne();
		//trace("Client's close traced."); This one isn't traced. Need to fix. 
		client.Close();
		super.destroy();
	}
}