package pony.fs.nodejs;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import js.node.Fs;
import js.node.fs.Stats;
import js.node.Buffer;
#if (haxe_ver >= '4.0.0')
import js.lib.Error;
#else
import js.Error;
#end
import pony.ds.ReadStream;
import pony.ds.WriteStream;

/**
 * FileReadStream
 * @author AxGord <axgord@gmail.com>
 */
class FileReadStream extends ReadStream<Bytes> {

	private static inline var DEFAULT_BLOCK_SIZE: Int = 4 * 1024 * 1024; // 4 mb
	private var writeStream: WriteStream<Bytes>;
	private var fd: Int;
	private var buffer: Buffer;
	private var size: Int;
	private var position: Int = 0;
	private var stop: Bool = false;
	private var path: String;
	private var readLast: Bool = false;

	public function new(path: String) {
		this.path = path;
		writeStream = new WriteStream<Bytes>();
		super(writeStream.base);
		writeStream.onGetData < open;
		writeStream.onCancel < getEndHandler;
	}

	private function open(): Void {
		Fs.open(path, 'r', openHandler);
		writeStream.onGetData << read;
	}

	private function getEndHandler(): Void stop = true;

	private function openHandler(err: Error, fd: Int): Void {
		if (stop) return;
		if (err == null) {
			this.fd = fd;
			Fs.fstat(fd, statHandler);
		} else {
			writeStream.error();
		}
	}

	private function statHandler(err: Error, stats: Stats): Void {
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

	private function read(): Void {
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

	private function readHandler(err: Error, bytesRead: Int, buffer: Buffer): Void {
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