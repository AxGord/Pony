/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.cs;
#if cs
import cs.NativeArray;
import cs.system.Byte;
import cs.system.IAsyncResult;
import cs.system.net.sockets.AddressFamily;
import cs.system.net.sockets.ProtocolType;
import cs.system.net.sockets.SelectMode;
import cs.system.net.sockets.Socket;
import cs.system.net.sockets.SocketFlags;
import cs.system.net.sockets.SocketShutdown;
import cs.system.net.sockets.SocketType;
import cs.types.UInt8;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.net.SocketClientBase;

using pony.Tools;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class SocketClient extends SocketClientBase {

	private var socket:Socket;
	private var buffer:NativeArray<UInt8>;
	private var sendProccess:Bool;
	private var closeAfterSend:Bool;
	
	override public function open():Void {
		if (!closed) return;
		socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
		socket.BeginConnect(host, port, untyped __cs__('connectCallback'), null);
	}
	
	private function connectCallback(ar:IAsyncResult):Void {
		try {
			socket.EndConnect(ar);
			initCS(socket);
		} catch (_:Dynamic) {
			trace('connect error');
			reconnect();
		}
	}
	
	public function initCS(s:Socket):Void {
		sendProccess = false;
		closeAfterSend = false;
		buffer = new NativeArray<UInt8>(1024);
		socket = s;
		endInit();
		waitData();
		connect.dispatch();
	}
	
	private function waitData():Void {
		socket.BeginReceive(buffer, 0, buffer.Length, SocketFlags.None, untyped __cs__('readCallback'), null);
	}
	
	private function readCallback(ar:IAsyncResult):Void {
		if (closed) return;
		try {
			var bytesRead:Int = socket.EndReceive(ar);
			if (bytesRead > 0) {
				data.dispatch(new BytesInput(Bytes.ofData(cast buffer)).cut());
				waitData();
			} else _close();
			
			/*
			if (socketConnected(socket)) {
				waitData();
				
			} else {
				_close();
			}
			*/
		} catch (_:Dynamic) {
			_close();
		}
	}
	/*
	inline private static function socketConnected(s:dotnet.system.net.sockets.Socket):Bool {
		var part1:Bool = s.Poll(1000, SelectMode.SelectRead);
		var part2:Bool = s.Available == 0;
		return !(part1 && part2);
	}
	*/
	private function disconnectCallback(ar:IAsyncResult):Void {
		socket.EndDisconnect(ar);
		socket.Close();
		disconnect.dispatch();
	}
	
	public function send(data:BytesOutput):Void {
		sendProccess = true;
		var b = data.getBytes();
		socket.BeginSend(cast b.getData(), 0, b.length, SocketFlags.None, untyped __cs__('sendCallback'), null);
	}
	
	private function sendCallback(ar:IAsyncResult):Void {
		socket.EndSend(ar);
		sendProccess = false;
		if (closeAfterSend) _close();
	}
	
	inline public function close():Void {
		if (!sendProccess) _close();
		else closeAfterSend = true;
	}
	
	private function _close():Void {
		closeAfterSend = false;
		if (closed) return;
		closed = true;
		socket.Shutdown(SocketShutdown.Both);
		socket.BeginDisconnect(true, untyped __cs__('disconnectCallback'), socket);
	}
	
}
#end