/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package pony.net.cs;
#if cs

import cs.NativeArray.NativeArray;
import cs.system.IAsyncResult;
import cs.system.AsyncCallback;
import cs.system.net.IPEndPoint;
import cs.system.net.IPAddress;
import cs.system.net.sockets.Socket;
import cs.system.net.sockets.SocketFlags;
import cs.system.net.sockets.SocketException;
import cs.system.net.sockets.AddressFamily;
import cs.system.net.sockets.SocketType;
import cs.system.net.sockets.ProtocolType;
import cs.system.threading.ManualResetEvent;
import cs.system.threading.Thread;
import cs.types.UInt8;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.net.SocketClient;
import pony.cs.Synchro;
import pony.Queue.Queue;

/**
 * SocketServer
 * @author DIS
 */
class SocketServer extends SocketServerBase 
{

	/**
	 * A server socket used to begin and end asynchronous operations.
	 **/
	private var server:Socket;
	/**
	 * A number o port to set an end point.
	 **/
	private var port:Int;
	/**
	 * An event that signals if accept callback ends. Using in destroy function.
	 **/
	private var eventAccept:ManualResetEvent = new ManualResetEvent(true);
	/**
	 * An event that signals if receive callback ends. Using in destroy function.
	 **/
	private var eventReceive:ManualResetEvent = new ManualResetEvent(true);
	/**
	 * A flag that indicates if send-receive process is running.
	 **/
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
			Synchro.lock(clients, function() clients.push(cl));
			try
			{
				cl.receiveBuffer = new NativeArray(4);
				cl.isSet = false;
				cl.client.BeginReceive(cl.receiveBuffer, 0, cl.receiveBuffer.Length, SocketFlags.None, new AsyncCallback(cl.receiveCallback), cl);
				@:privateAccess cl.connect();
				s.BeginAccept(new AsyncCallback(acceptCallback), ar.AsyncState);	
			}
			catch (ex:SocketException)
			{
				closeConnection(cl);
				error(ex.get_Message());
			}
		}
		eventAccept.Set();
	}
	
	private function closeConnection(cl:SocketClient):Void
	{
		cl.client.Close();
		Synchro.lock(clients, function() clients.remove(cl));
	}
	
	private function clInit():SocketClient
	{
		var cl:SocketClient = Type.createEmptyInstance(SocketClient);
		Synchro.lock(clients, function() cl.init(cast this, clients.length));
		cl.sendQueue = new Queue(cl._send);
		cl.isRunning = true;
		cl.eventReceive = new ManualResetEvent(true);
		cl.eventSend = new ManualResetEvent(true);
		return cl;
	}
	
	override public function destroy():Void
	{
		super.destroy();
		isRunning = false;
		var destrThread:Thread = new Thread(new cs.system.threading.ThreadStart(function()
		{
			eventReceive.WaitOne();
			//trace("Server's close traced.");
			eventAccept.WaitOne();//The events DO guarantee that executing callbacks finish correct and DO NOT guarantee that next callbacks will execute so it may cause a loss of data;
			server.Close();		  //to prevent this situation there is a Sys.sleep(1) that makes main thread to wait for other threads to finish its executing. There's no more need in the Sys.sleep(1).
			
		}));
		destrThread.IsBackground = true;
		destrThread.Start();
	}
}
#end