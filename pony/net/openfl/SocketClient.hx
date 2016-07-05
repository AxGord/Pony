/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.openfl;

#if openfl
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.net.SocketClientBase;
import pony.time.DeltaTime;

import openfl.utils.ByteArray;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class SocketClient extends SocketClientBase {

	private var socket:Socket;
	private var q:Queue < BytesOutput->Void > ;
	
	override public function open():Void {
		super.open();
		q = new Queue(_send);
		socket = new Socket(host, port);
		socket.addEventListener(Event.CONNECT, connectHandler);
		socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		socket.addEventListener(Event.CLOSE, closeHandler);
		socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}
	
	//private function skipOutputProgressHandler():Void outputProgressHandler(null);
	
	private function outputProgressHandler(_):Void {
		socket.removeEventListener('outputProgress', outputProgressHandler);
		DeltaTime.skipUpdate(q.next);
	}
	
	private function securityErrorHandler(_):Void {}
	
	private function ioErrorHandler(event:IOErrorEvent):Void error(event.text);
	
	private function closeHandler(_):Void close();
	
	private function connectHandler(_):Void connect();
	
	public function send(data:BytesOutput):Void	q.call(data);
	
	private function _send(data:BytesOutput):Void {
		socket.addEventListener('outputProgress', outputProgressHandler);
		try {
			socket.writeBytes(ByteArray.fromBytes(data.getBytes()));
			socket.flush();
			//DeltaTime.skipUpdate(skipOutputProgressHandler);
		} catch (e:Dynamic) {
			error(e);
		}
	}
	
	override public function close():Void {
		super.close();
		try {
			socket.close();
		} catch (_:Dynamic) {}
	}
	
	private function socketDataHandler(_):Void {
		var b:ByteArray = new ByteArray();
		socket.readBytes(b);
		joinData(new BytesInput(b));
	}
	
}
#end