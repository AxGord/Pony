package pony.net.rpc;

import haxe.io.Bytes;
import pony.ds.ReadStream;
import pony.ds.WriteStream;
import pony.events.Signal0;
import pony.events.Signal1;

/**
 * RPC Bytes Stream
 * @author AxGord <axgord@gmail.com>
 */
#if (haxe_ver >= 4.2) final #else @:final #end
class RPCStream extends RPCUnit<RPCStream> implements IRPC {

	@:auto public var onRead: Signal1<ReadStream<Bytes>>;
	@:rpc public var onStreamData: Signal1<Bytes>;
	@:rpc public var onStreamEnd: Signal1<Bytes>;
	@:rpc public var onError: Signal0;
	@:rpc public var onGetData: Signal0;
	@:rpc public var onCancel: Signal0;
	@:rpc public var onComplete: Signal0;

	private var writeSream: WriteStream<Bytes>;
	private var readStream: ReadStream<Bytes>;

	public function new() {
		super();
		onStreamData < beginReadHandler;
	}

	public function write(rs: ReadStream<Bytes>): Void {
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

	private function beginReadHandler(data: Bytes): Void {
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

	private function endRead(): Void {
		onStreamEnd >> endRead;
		onError >> endRead;
		writeSream = null;

		onStreamData < beginReadHandler;
	}

	private function endWrite(): Void {
		onComplete >> endWrite;
		onCancel >> endWrite;
		onGetData >> readStream.next;
		onCancel >> readStream.cancel;
		onComplete >> readStream.complete;
		readStream = null;

		onStreamData < beginReadHandler;
	}

}
