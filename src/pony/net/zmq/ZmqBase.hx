package pony.net.zmq;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.events.Signal0;
import pony.net.SocketClient;

using pony.Tools;

/**
 * Zero MQ Base class
 * @author AxGord <axgord@gmail.com>
 */
class ZmqBase extends Logable {

	private static var REQUEST_RESPONSE_CODE: Bytes = Bytes.ofHex('03');
	private static var FIRST_MESSAGE_REQUEST: Bytes = Bytes.ofHex('FF00000000000000017F');
	private static var SECOND_MESSAGE_REQUEST: Bytes = Bytes.ofHex('004E554C4C' + [for (_ in 0...48) '00'].join(''));
	private static var THIRD_MESSAGE: Bytes = Bytes.ofHex('0552454144590B536F636B65742D5479706500000003'); // 0003  5355 4200 0101 for publisher

	@:auto public var onOpen: Signal0;
	public var opened(default, null): Bool = false;
	private var socket: SocketClient;
	private var clientMessagePrefix: Bytes;
	private var clientMessagePostfix: Bytes;
	private var serverMessagePrefix: Bytes;
	private var serverMessagePostfix: Bytes;

	private function new(
		host: String = '127.0.0.1', port: Int,
		clientMessagePrefix: Bytes, clientMessagePostfix: Bytes, serverMessagePrefix: Bytes, serverMessagePostfix: Bytes
	) {
		super('ZMQ');
		this.clientMessagePrefix = clientMessagePrefix;
		this.clientMessagePostfix = clientMessagePostfix;
		this.serverMessagePrefix = serverMessagePrefix;
		this.serverMessagePostfix = serverMessagePostfix;
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
		[clientMessagePrefix, THIRD_MESSAGE, clientMessagePostfix].joinBytes(),
		[serverMessagePrefix, THIRD_MESSAGE, serverMessagePostfix].joinBytes()
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