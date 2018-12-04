/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.net.neko;

#if neko
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Error;
import haxe.io.Eof;
import sys.net.Socket;
import sys.net.Host;
import pony.net.SocketClientBase;
import pony.time.DeltaTime;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class SocketClient extends SocketClientBase {

	private var socket:Socket;
	private var buffer:BytesOutput;
	private var q:Queue < BytesOutput -> Void >;
	
	override public function open():Void {
		super.open();
		socket = new Socket();
		socket.connect(new Host(host), port);
		_init();
	}

	private function _init():Void {
		q = new Queue(_send);
		socket.setBlocking(false);
		buffer = new BytesOutput();
		DeltaTime.fixedUpdate < connect;
		DeltaTime.fixedUpdate << updateHandler;
	}

	@:allow(pony.net.neko.SocketServer)
	private function nekoInit(client:Socket):Void {
		socket = client;
		_init();
	}

	private function updateHandler():Void {
		try {
			while (true) buffer.writeByte(socket.input.readByte());
		} catch (e:Error) {
			if (e != Error.Blocked)
				error(e.getName());
			else
				processBuffer();
		} catch (e:Eof) {
			log('eof');
			processBuffer();
			close();
		} catch (e:Any) {
			error(e);
		}
	}

	private function processBuffer():Void {
		if (buffer.length > readLengthSize) {
			joinData(new BytesInput(buffer.getBytes()));
			buffer.flush();
			buffer = new BytesOutput();
		} else if (buffer.length > 0) {
			buffer.flush();
			buffer = new BytesOutput();
		}
	}
	
	private function closeHandler(_):Void close();
	
	public function send(data:BytesOutput):Void q.call(data);
	
	private function _send(data:BytesOutput):Void {
		try {
			socket.output.write(data.getBytes());
			socket.output.flush();
		} catch (e:Dynamic) {
			error(e);
		}
		DeltaTime.fixedUpdate < q.next;
	}
	
	override public function close():Void {
		DeltaTime.fixedUpdate >> updateHandler;
		super.close();
		try {
			socket.close();
		} catch (_:Dynamic) {}
	}
	
}
#end