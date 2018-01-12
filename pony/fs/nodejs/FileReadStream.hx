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

class FileReadStream extends ReadStream<Bytes> {

	private static inline var DEFAULT_BLOCK_SIZE:Int = 4 * 1024 * 1024;// 4 mb
	private var writeStream:WriteStream<Bytes>;
	private var fd:Int;
	private var buffer:Buffer;
	private var size:Int;
	private var position:Int = 0;
	private var stop:Bool = false;
	private var path:String;
	private var readLast:Bool = false;

	public function new(path:String) {
		this.path = path;
		writeStream = new WriteStream<Bytes>();
		super(writeStream.base);

		writeStream.onGetData < open;
		writeStream.onCancel < getEndHandler;
	}

	private function open():Void {
		Fs.open(path, 'r', openHandler);
		writeStream.onGetData << read;
	}

	private function getEndHandler():Void stop = true;

	private function openHandler(err:js.Error, fd:Int):Void {
		if (stop) return;
		if (err == null) {
			this.fd = fd;
			Fs.fstat(fd, statHandler);
		} else {
			writeStream.error();
		}
	}
	
	private function statHandler(err:js.Error, stats:Stats):Void {
		if (stop) return;
		if (err == null) {
			size = cast stats.size;
			buffer = new Buffer(stats.blksize == null ? DEFAULT_BLOCK_SIZE : stats.blksize);
			var b:BytesOutput = new BytesOutput();
			b.writeFloat(size);
			writeStream.data(b.getBytes());
		} else {
			writeStream.error();
		}
	}

	private function read():Void {
		var len:Int = buffer.length;
		if (position + len > size)
			len = size - position;
		Fs.read(fd, buffer, 0, len, position, readHandler);
		position += len;

		if (position == size) {
			readLast = true;
		} else if (position > size) {
			writeStream.error();
		}
	}

	private function readHandler(err:js.Error, bytesRead:Int, buffer:Buffer):Void {
		if (stop) return;
		if (err == null) {
			var b:Bytes = Bytes.ofData(buffer.buffer.slice(0, bytesRead));
			if (readLast)
				writeStream.end(b);
			else
				writeStream.data(b);
		} else {
			writeStream.error();
		}
	}

}