package pony.net.zmq;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.net.SocketClient;

class ZmqClient extends Logable {

	private static var REQUEST_RESPONSE_CODE: Array<Int> = [0x03];
	private static var FIRST_MESSAGE_REQUEST: Array<Int> = [0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x7F];
	private static var SECOND_MESSAGE_REQUEST: Array<Int> = [0x00, 0x4E, 0x55, 0x4C, 0x4C].concat([for (_ in 0...48) 0x00]);
	private static var THIRD_MESSAGE: Array<Int> = [0x05, 0x52, 0x45, 0x41, 0x44, 0x59, 0x0B, 0x53, 0x6F, 0x63, 0x6B, 0x65, 0x74, 0x2D,
		0x54, 0x79, 0x70, 0x65, 0x00, 0x00, 0x00, 0x03, 0x52, 0x45];
	private static var CLIENT_THIRD_PREFIX: Array<Int> = [0x04, 0x26];
	private static var CLIENT_THIRD_POSTFIX: Array<Int> = [0x51, 0x08, 0x49, 0x64, 0x65, 0x6E, 0x74, 0x69, 0x74, 0x79, 0x00, 0x00, 0x00, 0x00];
	private static var SERVER_THIRD_PREFIX: Array<Int> = [0x04, 0x19];
	private static var SERVER_THIRD_POSTFIX: Array<Int> = [0x50];

	private var socket: SocketClient;

	public function new(host: String = '127.0.0.1', port: Int) {
		super();
		socket = new SocketClient(host, port, -1, 0, false);
		listenErrorAndLog(socket);
		socket.onConnect < connectHandler;
		socket.onData < firstDataHandler;
	}

	private function connectHandler(): Void {
		socket.send(makeBytes(FIRST_MESSAGE_REQUEST));
	}

	private function firstDataHandler(bi: BytesInput): Void {
		if (checkBytes(bi, FIRST_MESSAGE_REQUEST.concat(REQUEST_RESPONSE_CODE))) {
			if (bi.position < bi.length) {
				error('First length error: ${bi.position} < ${bi.length}');
				destroy();
			} else {
				socket.onData << secondDataHander;
				socket.send(makeBytes(REQUEST_RESPONSE_CODE.concat(SECOND_MESSAGE_REQUEST)));
			}
		} else {
			error('Wrong first message');
			destroy();
		}
	}

	private function secondDataHander(bi: BytesInput): Void {
		if (checkBytes(bi, SECOND_MESSAGE_REQUEST)) {
			if (bi.position < bi.length) {
				error('Second length error: ${bi.position} < ${bi.length}');
				destroy();
			} else {
				socket.onData << thirdDataHander;
				socket.send(makeBytes(CLIENT_THIRD_PREFIX.concat(THIRD_MESSAGE).concat(CLIENT_THIRD_POSTFIX)));
			}
		} else {
			error('Wrong second message');
			destroy();
		}
	}
	private function thirdDataHander(bi: BytesInput): Void {
		if (checkBytes(bi, SERVER_THIRD_PREFIX.concat(THIRD_MESSAGE).concat(SERVER_THIRD_POSTFIX))) {
			if (bi.position < bi.length) {
				error('Third length error: ${bi.position} < ${bi.length}');
				destroy();
			} else {
				socket.onData << dataHandler;
			}
		} else {
			error('Wrong third message');
			destroy();
		}
	}

	private function dataHandler(bi: BytesInput): Void {
		trace('data', bi.length);
	}

	private static function makeBytes(a: Array<Int>): BytesOutput {
		var bo: BytesOutput = new BytesOutput();
		addBytes(bo, a);
		return bo;
	}

	private static function addBytes(bo: BytesOutput, a: Array<Int>): BytesOutput {
		for (b in a) bo.writeByte(b);
		return bo;
	}

	private static function checkBytes(bi: BytesInput, a: Array<Int>): Bool {
		for (b in a) if (b != bi.readByte()) return false;
		return true;
	}

	public function destroy(): Void {
		socket.destroySignals();
		socket.destroy();
	}

}