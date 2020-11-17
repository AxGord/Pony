package pony.net.zmq;

import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.net.SocketClient;

class ZmqClient extends Logable {

	private static inline var RESPONCE_CODE_LENGTH: Int = 1;
	private static inline var FIRST_MESSAGE_RESPONCE_LENGTH_A: Int = FIRST_MESSAGE_RESPONCE_LENGTH_B + RESPONCE_CODE_LENGTH;
	private static inline var FIRST_MESSAGE_RESPONCE_LENGTH_B: Int = 10;
	private static inline var SECOND_MESSAGE_RESPONCE_LENGTH_A: Int = 52;
	private static inline var SECOND_MESSAGE_RESPONCE_LENGTH_B: Int = 80;
	private static var REQUEST_RESPONSE_CODE: Array<Int> = [0x03];
	private static var FIRST_MESSAGE_REQUEST: Array<Int> = [0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x7F];
	private static var SECOND_MESSAGE_REQUEST: Array<Int> = [0x00, 0x4E, 0x55, 0x4C, 0x4C].concat([for (_ in 0...48) 0x00]);
	private static var THIRD_MESSAGE: Array<Int> = [0x05, 0x52, 0x45, 0x41, 0x44, 0x59, 0x0B, 0x53, 0x6F, 0x63, 0x6B, 0x65, 0x74, 0x2D,
		0x54, 0x79, 0x70, 0x65, 0x00, 0x00, 0x00, 0x03, 0x52, 0x45]; // 0003  5355 4200 0101 for publisher
	private static var CLIENT_CONCAT_THIRD_PREFIX: Array<Int> = [0x04, 0x19];
	private static var CLIENT_CONCAT_THIRD_POSTFIX: Array<Int> = [0x50];
	private static var CLIENT_THIRD_PREFIX: Array<Int> = [0x04, 0x26];
	private static var CLIENT_THIRD_POSTFIX: Array<Int> = [0x51, 0x08, 0x49, 0x64, 0x65, 0x6E, 0x74, 0x69, 0x74, 0x79, 0x00, 0x00, 0x00, 0x00];
	private static var SERVER_THIRD_PREFIX: Array<Int> = [0x04, 0x19];
	private static var SERVER_THIRD_POSTFIX: Array<Int> = [0x50];
	private static inline var DATA_CODE: Int = 0x01;
	private static inline var MAX_BYTE: Int = 0xFF;

	@:auto public var onOpen: Signal0;
	@:auto public var onData: Signal1<BytesInput>;
	public var opened(default, null): Bool = false;
	private var socket: SocketClient;
	private var first03complete: Int = 0;
	private var stack: Array<BytesOutput> = [];

	public function new(host: String = '127.0.0.1', port: Int) {
		super();
		socket = new SocketClient(host, port, -1, 0, false);
		listenErrorAndLog(socket, 'ZMQ');
		socket.onConnect < connectHandler;
	}

	private function connectHandler(): Void {
		sendBytes([FIRST_MESSAGE_REQUEST]) < firstDataHandler;
	}

	private function firstDataHandler(bi: BytesInput): Void {
		switch bi.length {
			case FIRST_MESSAGE_RESPONCE_LENGTH_A if (checkBytes(bi, [FIRST_MESSAGE_REQUEST, REQUEST_RESPONSE_CODE])):
				sendBytes([REQUEST_RESPONSE_CODE, SECOND_MESSAGE_REQUEST]) < secondDataHander;
			case FIRST_MESSAGE_RESPONCE_LENGTH_B if (checkBytes(bi, [FIRST_MESSAGE_REQUEST])):
				sendBytes([REQUEST_RESPONSE_CODE]) < first03DataHander;
			case _:
				wrongBytes(bi, 'first');
		}
	}

	private function first03DataHander(bi: BytesInput): Void {
		if (bi.length == RESPONCE_CODE_LENGTH && checkBytes(bi, [REQUEST_RESPONSE_CODE])) {
			first03complete = 1;
			sendBytes([SECOND_MESSAGE_REQUEST]) < secondDataHander;
		} else {
			wrongBytes(bi, 'first 03');
		}
	}

	private function secondDataHander(bi: BytesInput): Void {
		switch bi.length - first03complete {
			case SECOND_MESSAGE_RESPONCE_LENGTH_A if (checkBytes(bi, [SECOND_MESSAGE_REQUEST])):
				sendBytes([CLIENT_THIRD_PREFIX, THIRD_MESSAGE, CLIENT_THIRD_POSTFIX]) < thirdDataHander;

			case SECOND_MESSAGE_RESPONCE_LENGTH_B
			if (checkBytes(bi, [SECOND_MESSAGE_REQUEST, CLIENT_CONCAT_THIRD_PREFIX, THIRD_MESSAGE, CLIENT_CONCAT_THIRD_POSTFIX])):
				sendBytes([CLIENT_THIRD_PREFIX, THIRD_MESSAGE, CLIENT_THIRD_POSTFIX]);
				handshake();

			case _:
				wrongBytes(bi, 'second');
		}
	}

	private function thirdDataHander(bi: BytesInput): Void {
		if (checkBytes(bi, [SERVER_THIRD_PREFIX, THIRD_MESSAGE, SERVER_THIRD_POSTFIX]))
			handshake();
		else
			wrongBytes(bi, 'third');
	}

	private function handshake(): Void {
		log('Handshake');
		opened = true;
		socket.onData << dataHandler;
		for (bo in stack) socket.send(bo);
		stack = [];
		eOpen.dispatch();
	}

	public function send(bo: BytesOutput): Void {
		var r: BytesOutput = new BytesOutput();
		if (bo.length <= MAX_BYTE) {
			r.writeByte(DATA_CODE);
			r.writeByte(0x00);
			r.writeByte(0x00);
			r.writeByte(bo.length);
		} else {
			r.writeByte(DATA_CODE);
			r.writeByte(0x00);
			r.writeByte(0x02);
			for (_ in 0...5) r.writeByte(0x00);
			r.writeByte(DATA_CODE);
			r.writeByte(bo.length - MAX_BYTE);
		}
		r.write(bo.getBytes());
		if (opened)
			socket.send(r);
		else
			stack.push(r);
	}

	private function dataHandler(bi: BytesInput): Void {
		if (bi.readByte() == DATA_CODE && bi.readByte() == 0x00) {
			switch bi.readByte() {
				case 0x00:
					eData.dispatch(new BytesInput(bi.read(bi.readByte())));
				case 0x02:
					for (_ in 0...5) if (bi.readByte() != 0x00) {
						wrongBytes(bi, 'data');
						return;
					}
					if (bi.readByte() != 0x01) {
						wrongBytes(bi, 'data');
						return;
					}
					eData.dispatch(new BytesInput(bi.read(bi.readByte() + MAX_BYTE)));
				case _:
					wrongBytes(bi, 'data');
			}
		} else {
			wrongBytes(bi, 'data');
		}
	}

	private function sendBytes(arrays: Array<Array<Int>>): Signal2<BytesInput, SocketClient> {
		socket.send(makeBytes(arrays));
		return socket.onData;
	}

	private static function makeBytes(arrays: Array<Array<Int>>): BytesOutput {
		var bo: BytesOutput = new BytesOutput();
		addBytes(bo, arrays);
		return bo;
	}

	private static function addBytes(bo: BytesOutput, arrays: Array<Array<Int>>): BytesOutput {
		for (a in arrays) for (b in a) bo.writeByte(b);
		return bo;
	}

	private static function checkBytes(bi: BytesInput, arrays: Array<Array<Int>>): Bool {
		for (a in arrays) for (b in a) if (b != bi.readByte()) return false;
		return true;
	}

	public function wrongBytes(bi: BytesInput, packetName: String): Void {
		fatal('Wrong $packetName message, length: ${bi.length}');
	}

	public function fatal(message: String): Void {
		error(message);
		destroy();
	}

	public function destroy(): Void {
		socket.destroySignals();
		socket.destroy();
	}

}