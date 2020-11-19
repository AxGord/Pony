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

	private static inline var MAX_BYTE: Int = 0xFF;
	private static var DATA_CODE: Bytes = Bytes.ofHex('0100');

	@:auto public var onData: Signal1<BytesInput>;
	private var stack: Array<BytesOutput> = [];

	public function new(host: String = '127.0.0.1', port: Int) {
		var postfix: Bytes = Bytes.ofHex('5245');
		super(
			host, port,
			Bytes.ofHex('0426'), [postfix, Bytes.ofHex('51084964656E7469747900000000')].joinBytes(),
			Bytes.ofHex('0419'), [postfix, Bytes.ofHex('50')].joinBytes()
		);
		onOpen < openHandler;
		onOpen < listenData;
	}

	private function openHandler(): Void {
		for (bo in stack) socket.send(bo);
		stack = [];
	}

	private function listenData(): Void socket.setTaskb(DATA_CODE, 1) < dataFirstHandler;

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

	public function send(bo: BytesOutput): Signal1<BytesInput> {
		var r: BytesOutput = new BytesOutput();
		r.bigEndian = true;
		if (bo.length <= MAX_BYTE) {
			r.write(DATA_CODE);
			r.writeByte(0x00);
			r.writeByte(bo.length);
		} else {
			r.write(DATA_CODE);
			r.writeByte(0x02);
			var len: Int64 = bo.length;
			r.writeInt32(len.high);
			r.writeInt32(len.low);
		}
		r.write(bo.getBytes());
		if (opened)
			socket.send(r);
		else
			stack.push(r);
		return onData;
	}

	public function sendb(b: Bytes): Signal1<BytesInput> {
		var bo: BytesOutput = new BytesOutput();
		bo.write(b);
		return send(bo);
	}

}