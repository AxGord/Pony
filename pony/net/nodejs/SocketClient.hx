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
package pony.net.nodejs;
import pony.events.Waiter;
import pony.Queue;
#if nodejs
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
	
	private var socket:NodeNetSocket;
	private var q:Queue < BytesOutput->Void > ;
	
	override public function open():Void {
		socket = Node.net.connect(port, host);
		//connected = new Waiter();
		socket.on('connect', connectHandler);
		nodejsInit(socket);
	}
	
	public function nodejsInit(s:NodeNetSocket):Void {
		q = new Queue(_send);
		socket = s;
		s.on('data', dataHandler);
		s.on('end', closeHandler);
		s.on('error', reconnect);
		endInit();
	}
	
	private function closeHandler():Void
	{
		onDisconnect.dispatch();
		onDisconnect.destroy();
		onDisconnect = null;
	}
	
	private function connectHandler():Void {
		closed = false;
		connected.end();
	}
	
	public function send(data:BytesOutput):Void	q.call(data);
	
	public function _send(data:BytesOutput):Void socket.write(data.getBytes().getData(), null, q.next);
	
	private function dataHandler(d:NodeBuffer):Void joinData(new BytesInput(Bytes.ofData(d)));
	
	override public function destroy():Void {
		super.destroy();
		socket.end();
		socket = null;
		closed = true;
	}
	
}
#end