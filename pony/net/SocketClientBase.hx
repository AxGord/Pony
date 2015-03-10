/**
* Copyright (c) 2012-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.net;
#if !dox
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.Timer;
import pony.events.Waiter;
import pony.Logable;
#end
import haxe.io.Bytes;
import pony.events.*;

/**
 * SocketClientBase
 * @author AxGord <axgord@gmail.com>
 */
class SocketClientBase extends Logable<ISocketClient>{

	public var server(default,null):ISocketServer;
	public var onConnect(default,null):Signal1<ISocketServer, SocketClient>;
	public var onData(default,null):Signal1<SocketClient, BytesInput>;
	public var onString(default, null):Signal1<SocketClient, String>;
	public var onDisconnect(default,null):Signal;
	public var id(default,null):Int;
	public var host(default,null):String;
	public var port(default, null):Int;
	public var closed(default, null):Bool;
	public var isAbleToSend:Bool;
	public var connected:Waiter;
	public var isWithLength:Bool;
	
	private var reconnectDelay:Int = -1;
	
	//For big data
	private var waitNext:Int;
	private var waitBuf:BytesOutput;

	public function new(?host:String, port:Int, reconnect:Int = -1, aIsWithLength:Bool = true) 
	{
		super();
		connected = new Waiter();
		if (host == null) host = '127.0.0.1';
		this.host = host;
		this.port = port;
		this.reconnectDelay = reconnect;
		onConnect = Signal.create(null);
		connected.wait(function() isAbleToSend = true);
		isWithLength = aIsWithLength;
		_init();
		open();
	}
	
	private function readString(event:Event):Void {
		var b:BytesInput = event.args[0];
		onString.dispatch(b.readString(b.length));
		event.stopPropagation();
	}
	
	private function _init():Void {
		closed = true;
		id = -1;
		onData = Signal.create(cast this);
		onDisconnect = new Signal(this);
		
		onString = Signal.create(null);
		onString.takeListeners << function() onData.add(readString, -1000);
		onString.lostListeners << function() onData.remove(readString);
	}
	
	public function reconnect():Void {
		if (reconnectDelay == 0) {
			trace('Reconnect');
			open();
		}
		#if ((!dox && HUGS) || nodejs || flash)
		else if (reconnectDelay > 0) {
			trace('Reconnect after '+reconnectDelay+' ms');
			Timer.delay(open, reconnectDelay);
		}
		#end
	}
	
	public function open():Void {} //Server's init.
	
	inline private function endInit():Void {
		closed = false;
		if (server != null)
			server.onConnect.dispatch(cast this);
	}
	
	public function init(server:ISocketServer, id:Int):Void {
		_init();
		this.server = server;
		this.id = id;
		
		waitNext = 0;
		waitBuf = new BytesOutput();
		
		onData.add(server.onData.dispatchEvent);
		onDisconnect.add(server.onDisconnect.dispatchEvent);
		
		if (server.onString.haveListeners) onString << server.onString.dispatchEvent;
		
	}
	
	inline public function send2other(data:BytesOutput):Void server.send2other(data, cast this);
	
	private function joinData(bi:BytesInput):Void {
		if (server != null) isWithLength = server.isWithLength;
		if (isWithLength)
		{
			var size:Int = 0;
			var len:Int = 0;
			
			if (waitNext > 0) {
				size = waitNext;
				len = bi.length;
			} else {			
				size = bi.readInt32();
				len = bi.length - 4;//4 - int32
			}
			
			if (size > len) {
				waitNext = size - len;
				size = len;
				waitBuf.write(bi.read(size));
			} else {
				if (waitNext > 0) {
					waitNext = 0;
					waitBuf.write(bi.read(size));
					onData.dispatch(new BytesInput(waitBuf.getBytes()));
					waitBuf = new BytesOutput();
				} else {
					onData.dispatch(new BytesInput(bi.read(size)));
				}
			}
			
		}
		else
		{
			onData.dispatch(bi);
		}
	}
	/*
	 * The code written above is just equivalent of next one:
		 * var i = bi.readInt32();
		 * onData.dispatch(bi.read(i));
	 * */
	
	public function destroy():Void
	{
		closed = true;
		onConnect.destroy();
		onConnect = null;
		onData.destroy();
		onData = null;
		onString.destroy();
		onString = null;
	}
	
}