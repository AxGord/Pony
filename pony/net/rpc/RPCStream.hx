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
package pony.net.rpc;

import haxe.io.Bytes;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.ds.ReadStream;
import pony.ds.WriteStream;

/**
 * RPC Bytes Stream
 * @author AxGord <axgord@gmail.com>
 */
@:final class RPCStream extends pony.net.rpc.RPCUnit<RPCStream> implements pony.net.rpc.IRPC {

	@:auto public var onRead:Signal1<ReadStream<Bytes>>;

	@:rpc public var onStreamData:Signal1<Bytes>;
	@:rpc public var onStreamEnd:Signal1<Bytes>;
	@:rpc public var onError:Signal0;
	
	@:rpc public var onGetData:Signal0;
	@:rpc public var onCancel:Signal0;
	@:rpc public var onComplete:Signal0;

	private var writeSream:WriteStream<Bytes>;
	private var readStream:ReadStream<Bytes>;

	public function new() {
		super();
		onStreamData < beginReadHandler;
	}

	private function beginReadHandler(data:Bytes):Void {
		writeSream = new WriteStream<Bytes>();

		onStreamEnd < endRead;
		onError < endRead;

		onStreamData << writeSream.data;
		onStreamEnd << writeSream.end;
		onError << writeSream.error;
		writeSream.onGetData << getDataRemote;
		writeSream.onCancel << cancelRemote;
		writeSream.onComplete << completeRemote;
		eRead.dispatch(writeSream.readStream);
		writeSream.data(data);
	}

	public function write(rs:ReadStream<Bytes>):Void {
		onStreamData >> beginReadHandler;
		readStream = rs;

		onComplete < endWrite;
		onCancel < endWrite;

		readStream.onData << streamDataRemote;
		readStream.onEnd << streamEndRemote;
		readStream.onError << errorRemote;
		onGetData << readStream.next;
		onCancel << readStream.cancel;
		onComplete << readStream.complete;

		readStream.next();
	}

	private function endRead():Void {
		onStreamEnd >> endRead;
		onError >> endRead;
		writeSream = null;

		onStreamData < beginReadHandler;
	}

	private function endWrite():Void {
		onComplete >> endWrite;
		onCancel >> endWrite;
		onGetData >> readStream.next;
		onCancel >> readStream.cancel;
		onComplete >> readStream.complete;
		readStream = null;

		onStreamData < beginReadHandler;
	}

}