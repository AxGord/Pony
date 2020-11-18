package pony.net.zmq;

import haxe.Int64;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.net.SocketClient;

class ZmqClient extends Logable {

	private static inline var MAX_BYTE: Int = 0xFF;

	private static var REQUEST_RESPONSE_CODE: Bytes = Bytes.ofHex('03');
	private static var FIRST_MESSAGE_REQUEST: Bytes = Bytes.ofHex('FF00000000000000017F');
	private static var SECOND_MESSAGE_REQUEST: Bytes = Bytes.ofHex('004E554C4C' + [for (_ in 0...48) '00'].join(''));
	private static var THIRD_MESSAGE: Bytes = Bytes.ofHex('0552454144590B536F636B65742D54797065000000035245'); // 0003  5355 4200 0101 for publisher
	private static var CLIENT_THIRD_PREFIX: Bytes = Bytes.ofHex('0426');
	private static var CLIENT_THIRD_POSTFIX: Bytes = Bytes.ofHex('51084964656E7469747900000000');
	private static var SERVER_THIRD_PREFIX: Bytes = Bytes.ofHex('0419');
	private static var SERVER_THIRD_POSTFIX: Bytes = Bytes.ofHex('50');
	private static var DATA_CODE: Bytes = Bytes.ofHex('0100');

	@:auto public var onOpen: Signal0;
	@:auto public var onData: Signal1<BytesInput>;
	public var opened(default, null): Bool = false;
	private var socket: SocketClient;
	private var first03complete: Int = 0;
	private var stack: Array<BytesOutput> = [];

	public function new(host: String = '127.0.0.1', port: Int) {
		super();
		socket = new SocketClient(host, port, -1, 0, false);
		socket.onTaskError << fatal.bind('task error');
		listenErrorAndLog(socket, 'ZMQ');
		socket.onConnect < connectHandler;
	}

	private static function concatBytes(bs: Array<Bytes>): Bytes {
		var bo: BytesOutput = new BytesOutput();
		for (b in bs) bo.write(b);
		return bo.getBytes();
	}

	private function connectHandler(): Void socket.sendSetTaskSym(FIRST_MESSAGE_REQUEST) < firstTaskHandler;
	private function firstTaskHandler(): Void socket.sendSetTaskSym(REQUEST_RESPONSE_CODE) < secondTaskHandler;
	private function secondTaskHandler(): Void socket.sendSetTaskSym(SECOND_MESSAGE_REQUEST) < thirdTaskHandler;
	private function thirdTaskHandler(): Void socket.sendSetTask(
		concatBytes([CLIENT_THIRD_PREFIX, THIRD_MESSAGE, CLIENT_THIRD_POSTFIX]),
		concatBytes([SERVER_THIRD_PREFIX, THIRD_MESSAGE, SERVER_THIRD_POSTFIX])
	) < handshake;

	private function handshake(): Void {
		log('ZMQ Handshake');
		opened = true;
		listenData();
		for (bo in stack) socket.send(bo);
		stack = [];
		eOpen.dispatch();
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

	public function send(bo: BytesOutput): Void {
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
	}

	public function fatal(message: String): Void {
		error(message);
		destroy();
	}

	public function destroy(): Void {
		destroySignals();
		socket.destroy();
	}

}