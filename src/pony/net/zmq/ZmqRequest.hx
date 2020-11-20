package pony.net.zmq;

import haxe.Int64;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.events.Signal1;

using pony.Tools;

/**
 * ZeroMQ Request
 * @author AxGord <axgord@gmail.com>
 */
class ZmqRequest extends ZmqBase {

	@:auto public var onData: Signal1<BytesInput>;
	@:auto public var onString: Signal1<String>;

	public function new(host: String = '127.0.0.1', port: Int) {
		var postfix: Bytes = Bytes.ofHex('5245');
		super(
			host, port,
			Bytes.ofHex('0426'), [postfix, Bytes.ofHex('51084964656E7469747900000000')].joinBytes(),
			Bytes.ofHex('0419'), [postfix, Bytes.ofHex('50')].joinBytes()
		);
		onOpen < listenData;
		eString.onTake << takeStringListener;
		eString.onLost << lostStringListener;
	}

	private function takeStringListener(): Void onData << dataStringHandler;
	private function lostStringListener(): Void onData >> dataStringHandler;
	private function dataStringHandler(bi: BytesInput): Void eString.dispatch(bi.readAll().toString());

	private function listenData(): Void socket.setTaskb(ZmqBase.DATA_CODE, 1) < dataFirstHandler;

	private function dataFirstHandler(bi: BytesInput): Void {
		switch bi.readByte() {
			case 0x00: socket.setTask(1) < lenFirstHandler;
			case 0x02: socket.setTask(8) < lenSecondHandler;
			case _: fatal('data');
		}
	}

	private inline function listenLen(len: Int64): Void {
		socket.onTask < eData;
		socket.setTask(len) < listenData;
	}

	private function lenFirstHandler(bi: BytesInput): Void listenLen(bi.readByte());

	private function lenSecondHandler(bi: BytesInput): Void {
		bi.bigEndian = true;
		listenLen(Int64.make(bi.readInt32(), bi.readInt32()));
	}

	public inline function send(bo: BytesOutput): Signal1<BytesInput> {
		_send(bo);
		return onData;
	}

	public inline function sendBytes(b: Bytes): Signal1<BytesInput> {
		var bo: BytesOutput = new BytesOutput();
		bo.write(b);
		return send(bo);
	}

	public inline function sendString(s: String): Signal1<String> {
		var bo: BytesOutput = new BytesOutput();
		bo.writeString(s);
		send(bo);
		return onString;
	}

}