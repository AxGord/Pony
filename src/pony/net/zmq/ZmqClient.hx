package pony.net.zmq;

import pony.events.Signal2;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.net.SocketClient;

class ZmqClient extends Logable {

	private static inline var FIRST_MESSAGE_RESPONCE_LENGTH: Int = 11;
	private static inline var SECOND_MESSAGE_RESPONCE_LENGTH_A: Int = 52;
	private static inline var SECOND_MESSAGE_RESPONCE_LENGTH_B: Int = 80;
	private static var REQUEST_RESPONSE_CODE: Array<Int> = [0x03];
	private static var FIRST_MESSAGE_REQUEST: Array<Int> = [0xFF, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x7F];
	private static var SECOND_MESSAGE_REQUEST: Array<Int> = [0x00, 0x4E, 0x55, 0x4C, 0x4C].concat([for (_ in 0...48) 0x00]);
	private static var THIRD_MESSAGE: Array<Int> = [0x05, 0x52, 0x45, 0x41, 0x44, 0x59, 0x0B, 0x53, 0x6F, 0x63, 0x6B, 0x65, 0x74, 0x2D,
		0x54, 0x79, 0x70, 0x65, 0x00, 0x00, 0x00, 0x03, 0x52, 0x45];
	private static var CLIENT_CONCAT_THIRD_PREFIX: Array<Int> = [0x04, 0x19];
	private static var CLIENT_CONCAT_THIRD_POSTFIX: Array<Int> = [0x50];
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
	}

	private function connectHandler(): Void {
		sendBytes([FIRST_MESSAGE_REQUEST]) < firstDataHandler;
	}

	private function firstDataHandler(bi: BytesInput): Void {
		if (bi.length == FIRST_MESSAGE_RESPONCE_LENGTH && checkBytes(bi, [FIRST_MESSAGE_REQUEST, REQUEST_RESPONSE_CODE]))
			sendBytes([REQUEST_RESPONSE_CODE, SECOND_MESSAGE_REQUEST]) < secondDataHander;
		else
			wrongBytes(bi, 'first');
	}

	private function secondDataHander(bi: BytesInput): Void {
		switch bi.length {
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
		socket.onData << dataHandler;
	}

	private function dataHandler(bi: BytesInput): Void {
		trace('data', bi.length);
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