package pony.fs.nodejs;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import js.node.Fs;
import js.node.fs.Stats;
import js.node.Buffer;
import pony.ds.ReadStream;
import pony.ds.WriteStream;

/**
 * FileWriteStream
 * @author AxGord <axgord@gmail.com>
 */
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
		if (readStream.onData == null) return;
		size = b.getFloat(0);
		Fs.open(path, 'w', openHandler);
	}

	private function openHandler(err:js.Error, fd:Int):Void {
		if (readStream.onData == null) return;
		if (err == null) {
			this.fd = fd;
			readStream.onData << dataHandler;
			readStream.onEnd << endHandler;
			readStream.onError < cancel;
			readStream.next();
		} else {
			cancel();
		}
	}
	
	private function dataHandler(b:Bytes):Void {
		if (readStream.onData == null) return;
		Fs.write(fd, Buffer.hxFromBytes(b), 0, b.length, position, writeHandler);
	}

	private function writeHandler(err:js.Error, len:Int, buf:Buffer):Void {
		if (readStream.onData == null) return;
		position += len;
		if (err == null) {
			readStream.next();
		} else {
			cancel();
		}
	}

	private function endHandler(b:Bytes):Void {
		if (readStream.onData == null) return;
		Fs.write(fd, Buffer.hxFromBytes(b), 0, b.length, position, lastWriteHandler);
	}

	private function lastWriteHandler(err:js.Error, len:Int, buf:Buffer):Void {
		if (readStream.onData == null) return;
		if (err == null) {
			Fs.close(fd, closeHandler);
		} else {
			cancel();
		}
	}

	private function closeHandler(err:js.Error):Void {
		if (readStream.onData == null) return;
		if (err != null) {
			trace(err);
			readStream.cancel();
		} else {
			readStream.complete();
		}
	}

	public function cancel():Void {
		try {
			Fs.closeSync(fd);
			Fs.unlinkSync(path);
		} catch (_:Any) {}
		readStream.cancel();
	}

}