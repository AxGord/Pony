package pony.net.cs;

/**
 * SocketClient
 * @author DIS
 */

 import cs.NativeArray.NativeArray;
 import cs.StdTypes.UInt8;
 import cs.system.IAsyncResult;
 import cs.system.AsyncCallback;
 import cs.system.net.IPAddress;
 import cs.system.net.sockets.SocketInformation;
 import cs.system.net.sockets.Socket;
 import cs.system.net.sockets.AddressFamily;
 import cs.system.net.sockets.SocketType;
 import cs.system.net.sockets.ProtocolType;
 import cs.system.net.sockets.SocketFlags;
 import cs.system.net.sockets.SocketException;
 import cs.system.threading.Thread;
 import cs.system.threading.ManualResetEvent;
 import haxe.io.BytesInput;
 import haxe.io.BytesOutput;
 import pony.cs.Synchro;
 import pony.net.SocketClientBase;
 import pony.Queue.Queue;
 
class SocketClient extends SocketClientBase
{
	
	/**
	 * A client socket used to begin and end asynchronous operations.
	 **/
	@:allow(pony.net.cs.SocketServer)
	private var client:Socket;
	/**
	 * Indicates if a client sended first or second datagramm; the first one is being sended if isSet is false, true instead.
	 **/
	@:allow(pony.net.cs.SocketServer)
	private var isSet:Bool = false;
	/**
	 * A receive buffer; by default, connection is considered to be with length so default size is 4.
	 **/
	@:allow(pony.net.cs.SocketServer)
	private var receiveBuffer:NativeArray<UInt8> = new NativeArray(4);
	/**
	 * A queue using to synchronize sending.
	 **/
	@:allow(pony.net.cs.SocketServer)
	private var sendQueue:Queue < BytesOutput -> Void > ;
	/**
	 * An event that signals if send callback ends. Using in destroy function.
	 **/
	@:allow(pony.net.cs.SocketServer)
	private var eventSend:ManualResetEvent = new ManualResetEvent(true);
	/**
	 * An event that signals if receive callback ends. Using in destroy function.
	 **/
	@:allow(pony.net.cs.SocketServer)
	private var eventReceive:ManualResetEvent = new ManualResetEvent(true);
	/**
	 * A flag that indicates if send-receive process is running.
	 **/
	@:allow(pony.net.cs.SocketServer)
	private var isRunning:Bool;
	/**
	 * A flag that indicates if client is connected.
	 **/
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
		Synchro.lock(sendQueue, function() sendQueue.call(data));
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
			Synchro.lock(sendQueue, function() sendQueue.next());
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
						//eventReceive.Set(); //Threre is a trouble like this: if eventReceive is set, then destroy inserted in onData handler executes every time the callback does,
											  //so an exception is raised because of the client being equal to null and the callback crashes. But if one doesn't set the event, the destroy
											  //stops waiting for event to set, so the callback stops too. Need to fix somehow. Fixed by adding a thread into destroy. 
						onData.dispatch(b_in);
						var buffer:NativeArray<UInt8> = new NativeArray(4);
						this.receiveBuffer = buffer;
						isSet = false;
						Synchro.lock(client, function() 
						{
							if (client != null && client.Connected) client.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), this); //Костыль для убиения бага. 
						} );
						
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
							onData.dispatch(b_in);//This will work uncorrect if length of datagramm is greater than 255. 
						}
						this.receiveBuffer = buffer;
						isSet = true;
						Synchro.lock(client, function() 
						{
							if (client != null && client.Connected) client.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, new AsyncCallback(receiveCallback), this);
						});
						
					}
				}
				else
				{

				}
			}
			catch (ex:Dynamic)
			{
				_error(ex);
			}
		}
		//trace(isRunning); //This trace, being uncommented, comletely burns program to the ground. Although it doesn't do, fixed somehow. 
		eventReceive.Set();
	}
	
	public override function destroy():Void
	{
		isRunning = false;
		var destrThread:Thread = new Thread(new cs.system.threading.ThreadStart(function()
		{
			eventReceive.WaitOne();
			eventSend.WaitOne();
			//trace("Client's close traced."); This one isn't traced. Need to fix. "three-fourth-fixed", see commetary below. Seems to be completely fixed, but there's one more bug. 
			Synchro.lock(client, function() 
			{
				var flag:Bool = true;
				try
				{
					client.Shutdown(cs.system.net.sockets.SocketShutdown.Both);
					client.Disconnect(false);//These two strings may cause a crash. Use them at your own risk - or just comment so as "trace(ex);" above too. The problem is: when Close
											 //having been executed, receive callback tries to execute one more time (although it hasn't to) and crashes the program because client becomes
											 //null. To prevent this trying to receive I added the Shutdown and Disconnect but they don't work the way it should - or I misunderstood their 
											 //working.
											 //There were a few time when Disconnect raised an exception as if it waits for client to be alive but one is not. It's really strange behaviour
											 //because client must be alive - Close isn't called at the time Disconnect is. It looks like Disconnect is called twice for one client. The temporary 
											 //solve of this problem is just not to use Disconnect and swallow the exception raising because of it. 
											 //By now there's no need in commenting something because execption raised by Disconnect is caught by using try-catch block and Close executes anyhow.
											 //But it isn't the best way to solve the problem, though.
											 //By now client is locked so there is no race condition anymore, fixed. 
				}
				catch(ex:Dynamic)
				{
					flag = false;
					client.Close();
				}
				if (flag) client.Close(); 
			} );
			
			closed = true;
			onData.destroy();
			onData = null;
		}));
		destrThread.IsBackground = true;
		destrThread.Start();
	}
}