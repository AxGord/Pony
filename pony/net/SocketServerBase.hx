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
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.events.*;
import pony.events.Signal1;
import pony.Logable.Logable;

/**
 * SocketServerBase
 * @author AxGord <axgord@gmail.com>
 */
#if !openfl
class SocketServerBase extends Logable<ISocketServer> {
	
	public var id(default,null):Int = -1;
	public var onData(default, null):Signal1<SocketClient, BytesInput>;
	public var onConnect(default, null):Signal1<ISocketServer, SocketClient>;
	public var onClose(default, null):Signal;
	public var onDisconnect(default, null):Signal;
	public var clients(default, null):Array<SocketClient>;
	public var onMessage(default, null):Signal1<SocketServer, String>;
	public var onError(default, null):Signal1<SocketServer, String>;
	public var isAbleToSend:Bool = false;
	public var isWithLength:Bool = true;
	
	private function new() {
		super();
		onConnect = Signal.create(cast this);
		onMessage = Signal.create(cast this);
		onError = Signal.create(cast this);
		onDisconnect = new Signal();
		onData = Signal.create(null);
		onClose = new Signal(this);
		clients = [];
		onDisconnect.add(removeClient);
		onConnect < function() isAbleToSend = true;
	}
	
	private function addClient():SocketClient {
		var cl = Type.createEmptyInstance(SocketClient);
		cl.isWithLength = isWithLength;
		cl.init(cast this, clients.length);
		clients.push(cl);
		return cl;
	}
	
	inline private function removeClient(cl:SocketClient):Void clients.remove(cl);
	
	/**
	 * Sends a data to all the clients. 
	 **/
	public function send(data:BytesOutput):Void {
		var bs = data.getBytes();
		for (c in clients) {
			var b = new BytesOutput();
			b.write(bs);
			c.send(b);
		}
	}
	
	/**
	 * Sends a data to all the clients except chosen one. 
	 **/
	public function send2other(data:BytesOutput, exception:SocketClient):Void {
		var bs = data.getBytes();
		for (c in clients) {
			if (c == exception) continue;
			var b = new BytesOutput();
			b.write(bs);
			c.send(b);
		}
	}
	
	/**
	 * One should remember that a destroy function _must_ be called from a thread in which the server was created. 
	 **/
	public function destroy():Void 
	{
		onClose.dispatch();
		onData.destroy();
		onData = null;
		onConnect.destroy();
		onConnect = null;
		onClose.destroy();
		onClose = null;
		onDisconnect.destroy();
		onDisconnect = null;
	}
}
#end