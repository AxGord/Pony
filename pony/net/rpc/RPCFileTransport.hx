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
import pony.fs.FileReadStream;
import pony.fs.FileWriteStream;

/**
 * FileTransport
 * @author AxGord <axgord@gmail.com>
 */
@:final class RPCFileTransport extends pony.net.rpc.RPCUnit<RPCFileTransport> implements pony.net.rpc.IRPC {

	@:sub public var stream:RPCStream;

	@:rpc public var onFile:Signal1<String>;

	private var fileWrite:FileWriteStream;

	public function new() {
		super();
		onFile << fileHandler;
	}

	public function sendFile(path:String, ?newPath:String):Void {
		if (newPath == null) newPath = path;
		fileRemote(newPath);
		var fs:FileReadStream = new FileReadStream(path);
		stream.write(fs);
	}

	private function fileHandler(path:String):Void {
		fileWrite = new FileWriteStream(changePath(path));
		stream.onRead < readHandler;
	}

	private function readHandler(rs:ReadStream<Bytes>):Void {
		fileWrite.pipe(rs);
	}

	public dynamic function changePath(path:String):String return path;
	
}