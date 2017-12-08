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
package pony.net.nodejs;

#if nodejs

import pony.Queue;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import js.Node;
import pony.net.SocketClientBase;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class SocketClient extends SocketClientBase {
	
	private var socket:js.node.net.Socket;
	private var q:Queue < BytesOutput->Void > ;
	
	override private function open():Void {
		super.open();
		socket = js.node.Net.connect(port, host);
		socket.on('connect', connect);
		nodejsInit(socket);
	}
	
	@:allow(pony.net.nodejs.SocketServer)
	private function nodejsInit(s:js.node.net.Socket):Void {
		q = new Queue(_send);
		socket = s;
		s.on('data', dataHandler);
		s.on('end', close);
		s.on('error', error.bind('socket error'));
	}
	
	override private function close():Void {
		super.close();
		if (socket != null) {
			socket.end();
			socket.destroy();
			socket = null;
		}
	}
	
	public function send(data:BytesOutput):Void	q.call(data);
	
	private function _send(data:BytesOutput):Void {
		socket.write(js.node.Buffer.hxFromBytes(data.getBytes()), sendNextAfterTimeout);
	}

	private function sendNextAfterTimeout():Void {
		pony.time.DeltaTime.skipUpdate(q.next);
	}

	private function dataHandler(d:js.node.Buffer):Void joinData(new BytesInput(Bytes.ofData(d.buffer)));
	
}

#end