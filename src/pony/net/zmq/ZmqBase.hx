package pony.net.zmq;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.events.Signal0;
import pony.net.SocketClient;

using pony.Tools;

class ZmqBase extends Logable {

	private static var REQUEST_RESPONSE_CODE: Bytes = Bytes.ofHex('03');
	private static var FIRST_MESSAGE_REQUEST: Bytes = Bytes.ofHex('FF00000000000000017F');
	private static var SECOND_MESSAGE_REQUEST: Bytes = Bytes.ofHex('004E554C4C' + [for (_ in 0...48) '00'].join(''));
	private static var THIRD_MESSAGE: Bytes = Bytes.ofHex('0552454144590B536F636B65742D5479706500000003'); // 0003  5355 4200 0101 for publisher
	private static var CLIENT_THIRD_PREFIX: Bytes = Bytes.ofHex('0426');
	private static var CLIENT_THIRD_POSTFIX: Bytes = Bytes.ofHex('51084964656E7469747900000000');
	private static var SERVER_THIRD_PREFIX: Bytes = Bytes.ofHex('0419');
	private static var SERVER_THIRD_POSTFIX: Bytes = Bytes.ofHex('50');

	@:auto public var onOpen: Signal0;
	public var opened(default, null): Bool = false;
	private var socket: SocketClient;
	private var message: Bytes;

	private function new(host: String = '127.0.0.1', port: Int, message: Bytes) {
		super('ZMQ');
		this.message = message;
		socket = new SocketClient(host, port, -1, 0, false);
		socket.enableLogInputData();
		socket.onTaskError << fatal.bind('task error');
		listenErrorAndLog(socket);
		socket.onConnect < connectHandler;
	}

	private function connectHandler(): Void socket.sendSetTaskSym(FIRST_MESSAGE_REQUEST) < firstTaskHandler;
	private function firstTaskHandler(): Void socket.sendSetTaskSym(REQUEST_RESPONSE_CODE) < secondTaskHandler;
	private function secondTaskHandler(): Void socket.sendSetTaskSym(SECOND_MESSAGE_REQUEST) < thirdTaskHandler;
	private function thirdTaskHandler(): Void socket.sendSetTask(
		[CLIENT_THIRD_PREFIX, THIRD_MESSAGE, message, CLIENT_THIRD_POSTFIX].joinBytes(),
		[SERVER_THIRD_PREFIX, THIRD_MESSAGE, message, SERVER_THIRD_POSTFIX].joinBytes()
	) < handshake;

	private function handshake(): Void {
		log('Handshake');
		opened = true;
		eOpen.dispatch();
	}

	public function fatal(msg: String): Void {
		error(msg);
		destroy();
	}

	public function destroy(): Void {
		destroySignals();
		socket.destroy();
	}

}