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
		writeSream.data(data);

		onStreamEnd < endRead;
		onError < endRead;

		onStreamData << writeSream.data;
		onStreamEnd << writeSream.end;
		onError << writeSream.error;
		writeSream.onGetData << getDataRemote;
		writeSream.onCancel << cancelRemote;
		writeSream.onComplete << completeRemote;
		eRead.dispatch(writeSream.readStream);
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