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
#end
import haxe.io.Bytes;
import pony.events.*;

/**
 * SocketClientBase
 * @author AxGord <axgord@gmail.com>
 */
class SocketClientBase {

	public var server(default,null):SocketServer;
	public var connect(default,null):Signal1<SocketServer, SocketClient>;
	public var data(default,null):Signal1<SocketClient, BytesInput>;
	public var disconnect(default,null):Signal;
	public var id(default,null):Int;
	public var host(default,null):String;
	public var port(default, null):Int;
	public var closed(default, null):Bool;
	
	private var reconnectDelay:Int = -1;
	
	public function new(?host:String, port:Int, reconnect:Int=-1) {
		//trace('Create socket client');
		if (host == null) host = '127.0.0.1';
		this.host = host;
		this.port = port;
		this.reconnectDelay = reconnect;
		connect = Signal.create(null);
		_init();
		open();
	}
	
	inline private function _init():Void {
		closed = true;
		id = -1;
		data = Signal.create(cast this);
		disconnect = new Signal(this);
	}
	
	public function reconnect():Void {
		if (reconnectDelay == 0) {
			trace('Reconnect');
			open();
		}
		#if (!dox && HUGS)
		else if (reconnectDelay > 0) {
			trace('Reconnect after '+reconnectDelay+' ms');
			Timer.delay(open, reconnectDelay);
		}
		#end
	}
	
	public function open():Void {}
	
	inline private function endInit():Void {
		closed = false;
		if (server != null)
			server.connect.dispatch(cast this);
	}
	
	public function init(server:SocketServer, id:Int):Void {
		_init();
		this.server = server;
		this.id = id;
		data.add(server.data.dispatchEvent);
		disconnect.add(server.disconnect.dispatchEvent);
	}
	
	inline public function send2other(data:BytesOutput):Void server.send2other(data, cast this);
	
	private function joinData(bi:BytesInput):Void {
		data.dispatch(new BytesInput(bi.read(bi.readInt32())));
	}
	
}