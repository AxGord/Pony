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
	private var readStream:ReadStream<Bytes>;

	public function new() {
		super();
	}

	public inline function enable():Void {
		onFile << fileHandler;
		stream.onRead << readHandler;
	}

	public inline function disable():Void {
		onFile >> fileHandler;
		stream.onRead >> readHandler;
	}

	public function sendFile(path:String, ?newPath:String):Void {
		if (newPath == null) newPath = path;
		fileRemote(newPath);
		var fs:FileReadStream = new FileReadStream(path);
		stream.write(fs);
	}

	private function fileHandler(path:String):Void {
		fileWrite = new FileWriteStream(changePath(path));
		checkBegin();
	}

	private function readHandler(rs:ReadStream<Bytes>):Void {
		readStream = rs;
		checkBegin();
	}

	private function checkBegin():Void {
		if (readStream != null && fileWrite != null) {
			fileWrite.pipe(readStream);
			readStream = null;
		}
	}

	public dynamic function changePath(path:String):String return path;

	public function cancel():Void {
		if (fileWrite != null)
			fileWrite.cancel();
	}
	
}