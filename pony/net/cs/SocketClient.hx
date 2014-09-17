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
	private var isSet:Bool;
	//private var host:String;
	//private var port:Int;
	@:allow(pony.net.cs.SocketServer)
	private var receiveBuffer:NativeArray<UInt8> = new NativeArray(4);
	@:allow(pony.net.cs.SocketServer)
	private var sendQueue:Queue < BytesOutput -> Void > ;
	@:allow(pony.net.cs.SocketServer)
	private var eventSend:ManualResetEvent = new ManualResetEvent(false);
	@:allow(pony.net.cs.SocketServer)
	private var eventReceive:ManualResetEvent = new ManualResetEvent(false);
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
			client.BeginReceive(receiveBuffer, 0, receiveBuffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), this);
		}
	}
	
	public function send(data:BytesOutput):Void
	{
		sendQueue.call(data);
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
			sendQueue.next();
		}
		eventSend.Set();
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
						cl.client.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), cl);
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
		//Sys.sleep(1);
		isRunning = false;
		eventReceive.WaitOne();
		eventSend.WaitOne();
		client.Close();
		super.destroy();
	}
}