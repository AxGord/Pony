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
import com.dongxiguo.protobuf.binaryFormat.LimitableBytesInput;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.time.DeltaTime;
import pony.events.Signal;

/**
 * Protobuf+SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class Protobuf<A, B> {

	public var socket(default, set):SocketClient;
	public var data(default, null):Signal;
	public var onSend(default, null):Signal;
	private var fs:List < A->Void > ;
	
	private var a:Class<A>;
	private var b:Class<B>;
	private var awrite:A->BytesOutput->Void;
	private var bmerge:B->LimitableBytesInput->Void;
	
	public function new(a:Class<A>, b:Class<B>, awrite:A->BytesOutput->Void, bmerge:B->LimitableBytesInput->Void) {
		data = new Signal(this);
		onSend = new Signal(this);
		this.a = a;
		this.b = b;
		this.awrite = awrite;
		this.bmerge = bmerge;
		DeltaTime.update.add(trySend);
	}
	
	private function set_socket(s:SocketClient):SocketClient {
		if (socket != null) socket.data.remove(socketData);
		if (s != null) s.data.add(socketData);
		return socket = s;
	}
	
	public function send(f:A->Void):Void {
		if (fs == null) fs = new List < A->Void > ();
		fs.push(f);
	}
	
	private function trySend():Void {
		if (fs == null) return;
		if (socket == null || socket.closed) return;
		var builder:A = Type.createInstance(a, []);
		onSend.dispatch(builder);
		for (f in fs) f(builder);
		var output = new BytesOutput();
		awrite(builder, output);
		socket.send(output);
		fs = null;
	}
	
	private function socketData(input:BytesInput):Void {
		var builder:B = Type.createInstance(b, []);
		bmerge(builder, new LimitableBytesInput(input.readAll()));
		data.dispatch(builder);
	}
	
}