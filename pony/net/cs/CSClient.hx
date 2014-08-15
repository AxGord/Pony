package pony.net.cs;

#if cs
 import cs.system.IDisposable;
 import cs.system.net.sockets.Socket;
 import cs.system.net.IPEndPoint;
 import cs.system.net.IPHostEntry;
 import cs.system.net.Dns;
 import cs.system.net.IPAddress;
 import cs.system.net.sockets.SocketType;
 import cs.system.net.sockets.ProtocolType;
 import cs.system.net.sockets.SocketAsyncEventArgs;
 import cs.system.EventHandler_1;
 import cs.system.Object;
 import cs.system.net.sockets.SocketError;
 import cs.system.net.sockets.SocketException;
 import cs.system.net.sockets.SocketAsyncOperation;
 import cs.system.net.sockets.SocketShutdown;
 import cs.system.text.Encoding;
 import cs.system.threading.WaitHandle;
 import cs.system.threading.AutoResetEvent;
 import cs.system.threading.Thread;
 import cs.system.threading.ThreadStart;
 import cs.NativeArray;
 import cs.types.UInt8;
 import haxe.io.Bytes;
 import haxe.io.BytesInput;
 import haxe.io.BytesOutput;
 import pony.events.Signal;
 import pony.events.Signal0;
 import pony.events.Signal1;
 
 /**
 * CSClient
 * A C# client based on Async-methods.
 * @author DIS
 */
class CSClient implements IDisposable extends BaseSocket 
{
	private static inline var receiveOperation:Int = 1;
	private static inline var sendOperation:Int = 0;
	/**
	 * A size of receive buffer; 5120 bytes by default.
	 **/
	public var receiveBufferSize:Int = 5 * 1024;
	private var client:Socket;
	private var connected:Bool;
	private var hostEndPoint:IPEndPoint;
	private static var autoConnectEvent:AutoResetEvent;
	private static var autoSendReceiveEvents:NativeArray<AutoResetEvent>;
	private var connectThread:Thread;
	/**
	 * A signal that dispatches when data getting completed.
	 **/
	public var onData:Signal1<CSClient, BytesInput>;
	/**
	 * A signal that dispatches when connection completed.
	 **/
	public var onConnect:Signal0<CSClient>;
	
	/**
	 * Creates a new client. Type "127.0.0.1" if you want to use localhost as host. 
	 **/
	public override function new(hostName:String, port:Int):Void 
	{
		onConnect = Signal.create(this);
		onData = Signal.create(this);
		autoConnectEvent = new AutoResetEvent(false);
		autoSendReceiveEvents = new NativeArray<AutoResetEvent>(2);
		autoSendReceiveEvents[0] = new AutoResetEvent(false);
		autoSendReceiveEvents[1] =  new AutoResetEvent(false);
		var host:IPHostEntry = Dns.GetHostEntry(hostName);
		var addressList:NativeArray<IPAddress> = host.AddressList;
		this.hostEndPoint = new IPEndPoint(addressList[addressList.Length - 1], port);
		this.client = new Socket(this.hostEndPoint.AddressFamily, SocketType.Stream, cs.system.net.sockets.ProtocolType.Tcp);
		connectThread = new Thread(ThreadStart.FromHaxeFunction(funcConnect));
		connectThread.Start();
	}
	
	private function funcConnect():Void
	{
		Thread.Sleep(100);
		connect();
	}
	/*
	 * Notice, that a connect function is in the constructor now. It may become the reason of case when an OnConnect event isn't dispatched while a server onAccept actions have already been 
	 * executed. To prevent this situation one may declare the function as public, delete or comment a "this.connect()" string above and add a function call _after_ using OnConnect in an 
	 * application.
	 */
	/**
	 * Connects client to a chosen host/port. 
	 **/
	@:allow(pony.net.cs.SocketClient)
	private function connect():Void
	{
		var connectArgs:SocketAsyncEventArgs = new SocketAsyncEventArgs();
		connectArgs.UserToken = this.client;
		connectArgs.RemoteEndPoint = this.hostEndPoint;
		connectArgs.add_Completed(new EventHandler_1<SocketAsyncEventArgs>(onConnection));
		
		client.ConnectAsync(connectArgs);
		autoConnectEvent.WaitOne();
		var errorCode:SocketError = connectArgs.SocketError;
		if (errorCode != cs.system.net.sockets.SocketError.Success)
		{
			trace(errorCode);
			throw new SocketException();
		}
	}
	
	private function onConnection(sender:Object, e:SocketAsyncEventArgs):Void 
	{
		autoConnectEvent.Set();
		this.connected = (e.SocketError == cs.system.net.sockets.SocketError.Success);
		if (connected)
		{
			if (e.LastOperation == SocketAsyncOperation.Connect)
			{
				onConnect.dispatch();
				var s:Socket = cast(e.UserToken, Socket);
				var receiveBuf = new NativeArray<UInt8>(receiveBufferSize);
				e.SetBuffer(receiveBuf, 0, receiveBuf.Length);
				e.add_Completed(new EventHandler_1<SocketAsyncEventArgs>(onReceive));
				s.ReceiveAsync(e);
			}
		}
	}
	
	private function onReceive(sender:Object, e:SocketAsyncEventArgs):Void
	{
		var b_out:BytesOutput = new BytesOutput();
		for (i in 0...e.Buffer.Length) b_out.writeByte(e.Buffer[i]);
		var b:Bytes = b_out.getBytes();
		var b_in:BytesInput = new BytesInput(b);
		var size:Int = b_in.readInt32();
		var bi = new BytesInput(b_in.read(size));
		onData.dispatch(bi);
		var s:Socket = cast(e.UserToken, Socket);
		var receiveBuf = new NativeArray<UInt8>(receiveBufferSize);
		e.SetBuffer(receiveBuf, 0, receiveBuf.Length);
		s.ReceiveAsync(e);
	}
	
	/**
	 * Sends a data to a server.
	 **/
	public function send(message:BytesOutput):Void
	{
		if (this.connected)
		{
			var completeArgs:SocketAsyncEventArgs = new SocketAsyncEventArgs();
			completeArgs.UserToken = this.client;
			completeArgs.RemoteEndPoint = hostEndPoint;
			BaseSocket.baseSend(client, message, completeArgs);
		}
		else
		{
			throw new SocketException();
		}
	}
	
	/**
	 * Disconnects and closes client.
	 **/
	public function Dispose():Void 
	{
		autoConnectEvent.Close();
		autoSendReceiveEvents[sendOperation].Close();
		autoSendReceiveEvents[receiveOperation].Close();
		if (this.client.Connected)
		{
			this.client.Disconnect(false);
			this.client.Close();
		}
	}
}
#end
