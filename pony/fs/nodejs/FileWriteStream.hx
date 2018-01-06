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
package pony.fs.nodejs;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import js.node.Fs;
import js.node.fs.Stats;
import js.node.Buffer;
import pony.ds.ReadStream;
import pony.ds.WriteStream;

class FileWriteStream extends WriteStream<Bytes> {

	private var size:Float;
	private var fd:Int;
	private var path:String;
	private var position:Int = 0;

	public function new(path:String) {
		super();
		this.path = path;
		readStream.onData < getSize;
	}

	private function getSize(b:Bytes):Void {
		size = b.getFloat(0);
		Fs.open(path, 'w', openHandler);
	}

	private function openHandler(err:js.Error, fd:Int):Void {
		if (err == null) {
			this.fd = fd;
			readStream.onData << dataHandler;
			readStream.onEnd << endHandler;
			readStream.next();
		} else {
			readStream.cancel();
		}
	}
	
	private function dataHandler(b:Bytes):Void {
		Fs.write(fd, Buffer.hxFromBytes(b), 0, b.length, position, writeHandler);
	}

	private function writeHandler(err:js.Error, len:Int, buf:Buffer):Void {
		position += len;
		if (err == null) {
			readStream.next();
		} else {
			readStream.cancel();
		}
	}

	private function endHandler(b:Bytes):Void {
		Fs.write(fd, Buffer.hxFromBytes(b), 0, b.length, position, lastWriteHandler);
	}

	private function lastWriteHandler(err:js.Error, len:Int, buf:Buffer):Void {
		if (err == null) {
			Fs.close(fd, closeHandler);
		} else {
			readStream.cancel();
		}
	}

	private function closeHandler(err:js.Error):Void {
		if (err != null) {
			trace(err);
			readStream.cancel();
		} else {
			readStream.complete();
		}
	}

}