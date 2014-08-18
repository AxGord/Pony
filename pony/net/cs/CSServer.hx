package pony.net.cs;

#if cs
import cs.NativeArray.NativeArray;
import cs.Ref.Ref;
import cs.system.net.sockets.Socket;
import cs.system.threading.Mutex;
import cs.system.threading.Semaphore;
import cs.system.threading.Interlocked;
import cs.system.threading.AutoResetEvent;
import cs.system.threading.Monitor;
import cs.system.net.sockets.SocketAsyncEventArgs;
import cs.system.net.sockets.SocketAsyncOperation;
import cs.system.net.sockets.SocketException;
import cs.system.net.sockets.SocketType;
import cs.system.net.sockets.ProtocolType;
import cs.system.net.sockets.AddressFamily;
import cs.system.net.sockets.SocketOptionLevel;
//import cs.system.net.sockets.SocketOptionName;
import cs.system.net.IPAddress;
import cs.system.net.Dns;
import cs.system.net.IPEndPoint;
import cs.system.EventHandler_1;
import cs.system.Environment;
import cs.system.Object;
import cs.types.UInt8;
import Type;
import haxe.Int32;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.events.Signal;
import pony.events.Signal0;
import pony.events.Signal1;

/**
 * CSServer
 * A C# server based on Async-methods.
 * @author DIS
 **/
class CSServer extends BaseSocket
{
	private var server:Socket;
	private var mutex:Mutex;
	private var numConnectedSockets:Int;
	private var numConnections:Int;
	private var bufferSize:Int;
	//private var readWritePool:SocketAsyncEventArgsPool;
	private var semaphoreAcceptedClients:Semaphore;
	private var data:Bytes;
	private var bytesToSend:Bytes;
	private var writeEventArgsArr:NativeArray<SocketAsyncEventArgs>;
	private var socketArr:Array<Socket>;
	private var clientArr:Array<SocketClient>;
	private var numSocket:Int = 0;
	/**
	 * A size of receive buffer; 5120 bytes by default.
	 **/
	public var receiveBufferSize:Int = 5 * 1024;
	/**
	 * A signal that dispatches when acception completed.
	 **/
	public var onAccept:Signal1<CSServer, Socket>;
	/**
	 * A signal that dispatches when data getting completed.
	 **/
	public var onData:Signal1<CSServer, BytesInput>;
	
	/**
	 * Creates a new server. 
	 */
	public function new(port:Int):Void
	{
		onAccept = Signal.create(this);
		onData = Signal.create(this);
		mutex = new Mutex();
		bufferSize = 32767;
		this.numConnectedSockets = 0;
		this.numConnections = 1000000;
		writeEventArgsArr = new NativeArray(numConnections);
		socketArr = new Array();
		clientArr = new Array();
		this.semaphoreAcceptedClients = new Semaphore(numConnections, numConnections);

		start(port);
	}
	
	private function closeClientSocket(e:SocketAsyncEventArgs)
	{
		var token:Token = e.UserToken;
		this.internalCloseClientSocket(token, e);
	}
	
	private function internalCloseClientSocket(token:Token, e:SocketAsyncEventArgs)
	{
		token.Dispose();
		this.semaphoreAcceptedClients.Release();
		var numb:Ref<Int> = numConnectedSockets;
		Interlocked.Decrement(numb);
	}
	
	private function onAcceptCompleted(sender:Object, e:SocketAsyncEventArgs):Void
	{
	this.processAccept(e);
	onAccept.dispatch(socketArr[numSocket - 1]);
	}
	
	private function onIOCompleted(sender:Object, e:SocketAsyncEventArgs)
	{
		switch(e.LastOperation)
		{
			case SocketAsyncOperation.Receive:
				this.processReceive(e);
			default:
				throw new SocketException();
		}
	}
	
	function processAccept(e:SocketAsyncEventArgs):Void 
	{
		var s:Socket = e.AcceptSocket;
		if (s.Connected)
		{
			socketArr.push(s); //This section is potentially dangerous because of using global resources inside threads without any synchronization. 
			numSocket++;
			try
			{
				var readEventArgs:SocketAsyncEventArgs = new SocketAsyncEventArgs();
				readEventArgs.add_Completed(new EventHandler_1<SocketAsyncEventArgs>(onIOCompleted));
				var buf:NativeArray<UInt8> = new NativeArray(receiveBufferSize);
				readEventArgs.SetBuffer(buf, 0, receiveBufferSize);
				if (readEventArgs != null)
				{
					var token = new Token(s);
					readEventArgs.UserToken = token;
					var numb:Ref<Int>;
					numb = this.numConnectedSockets;
					Interlocked.Increment(numb);
					
					if (!s.ReceiveAsync(readEventArgs))
					{
						this.processReceive(readEventArgs);
					}
				}
				else
				{
					trace("There are no more available sockets to allocate.");
				}
			}
			catch (_:Dynamic)
			{
			}
			this.startAccept(e);
		}
	}
	
	private  function processError(e:SocketAsyncEventArgs)
	{
		var token:Token = e.UserToken;
		var localEp:IPEndPoint = cast(token.connection.LocalEndPoint, IPEndPoint);
		this.internalCloseClientSocket(token, e);
	}
	
	private function processReceive(e:SocketAsyncEventArgs):Void 
	{
		if (e.BytesTransferred > 0)
		{
			if (e.SocketError == cs.system.net.sockets.SocketError.Success)
			{
				var token:Token = e.UserToken;
				var b_in:BytesInput;
				b_in = token.setData(e);
				var size:Int = b_in.readInt32();
				var buf:NativeArray<UInt8> = new NativeArray(receiveBufferSize);
				e.SetBuffer(buf, 0, buf.Length);
				this.onData.dispatch(b_in);
				var s:Socket = token.connection;
				if (s.Available == 0)
				{
					if (!s.ReceiveAsync(e))
					{
						this.processReceive(e);
					}
				}
			}
			else
			{
				this.processError(e);
			}
		}
		else
		{
			this.closeClientSocket(e);
		}
	}
	
	/**
	 * Sends a data to all accepted clients. Among all functions this also is the most comfortable to use if just one client accepted because it isn't neccesary to type a number; a sendTo function is a little bit faster, though.
	 **/
	
	/*public function sendToAll(b:BytesOutput):Void
	{
		for (cl in socketArr) 
		{
			BaseSocket.baseSend(cl, b);
		}
	}*/
	
	/**
	 * Sends a data to chosen client. A num parameter may be got in OnAccept.
	 **/
	/*public function sendTo(num:Int, b:BytesOutput):Void 
	{
		BaseSocket.baseSend(socketArr[num], b);
	}*/
	
	/**
	 * Sends a data to all the clients except chosen one. An exception parameter may be got in OnAccept.
	 **/
	/*public function sendToOther(exception:Int, b:BytesOutput):Void
	{
		for (i in 0...socketArr.length)
		{
			BaseSocket.baseSend(socketArr[i], b);
			if (i == exception) continue;
		}
	}*/
	
	private function start(port:Int):Void
	{
		var addressList:NativeArray<IPAddress> = Dns.GetHostEntry(Environment.MachineName).AddressList;
		var localEndPoint:IPEndPoint = new IPEndPoint(addressList[addressList.Length - 1], port);
		
		this.server = new Socket(localEndPoint.AddressFamily, SocketType.Stream, ProtocolType.Tcp);
		this.server.ReceiveBufferSize = this.receiveBufferSize;
		this.server.SendBufferSize = this.bufferSize;
		
		this.server.Bind(localEndPoint);
		this.server.Listen(this.numConnections);
		this.startAccept(null);
		mutex.WaitOne();
	}
	
	private function startAccept(acceptEventArg: SocketAsyncEventArgs )
	{
		if (acceptEventArg == null)
		{
			acceptEventArg = new SocketAsyncEventArgs();
			acceptEventArg.add_Completed(new EventHandler_1<SocketAsyncEventArgs>(onAcceptCompleted));
		}
		else
		{
			acceptEventArg.AcceptSocket = null;
		}
		
		this.semaphoreAcceptedClients.WaitOne();
		if (!this.server.AcceptAsync(acceptEventArg))
		{
			this.processAccept(acceptEventArg);
		}
	}
	
	/**
	 * Stops server and closes socket.
	 **/
	public function stop():Void
	{
		mutex.ReleaseMutex();
		this.server.Close();
	}
}
#end
