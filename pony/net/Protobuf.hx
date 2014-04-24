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
import pony.magic.Declarator;
import pony.time.DeltaTime;
import pony.events.*;

typedef ProtobufBuilder = {
	function new():Void;
}

/**
 * Protobuf helper
 * @author AxGord <axgord@gmail.com>
 */
@:generic
class Protobuf < A:ProtobufBuilder, B:ProtobufBuilder > implements Declarator {
	
	@:arg public var socket(default, null):INet;
	@:arg private var awrite:A->BytesOutput->Void;
	@:arg private var bmerge:B->LimitableBytesInput->Void;
	public var onData(default, null):Signal1<Protobuf< A, B >, B> = Signal.create(this);
	public var onSend(default, null):Signal1<Protobuf< A, B >, A> = Signal.create(this);
	private var fs:List < A->Void > = new List();
	
	public function new() {
		socket.data.add(dataHandler);
		DeltaTime.fixedUpdate.add(trySend);
	}
	
	private function dataHandler(d:BytesInput):Void {
		var b:B = new B();
		bmerge(b, new LimitableBytesInput(d.readAll()));
		onData.dispatch(b);
	}

	public function send(f:A->Void):Void {
		if (fs == null) fs = new List < A->Void > ();
		fs.push(f);
	}
	
	private function trySend():Void {
		if (fs == null) return;
		if (socket == null) return;
		var builder:A = new A();
		onSend.dispatch(builder);
		for (f in fs) f(builder);
		var output = new BytesOutput();
		awrite(builder, output);
		socket.send(output);
		fs = null;
	}
	
}