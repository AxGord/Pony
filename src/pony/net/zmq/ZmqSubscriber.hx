package pony.net.zmq;

import haxe.Int64;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.events.Signal1;

using pony.Tools;

/**
 * ZeroMQ Subscriber
 * @author AxGord <axgord@gmail.com>
 */
class ZmqSubscriber extends ZmqBase {

	private static var SUBSCRIBE_CODE: Bytes = Bytes.ofHex('000101');
	private static var SUBJECT_CODE: Bytes = Bytes.ofHex('01');
	private static var DATA_CODE: Bytes = Bytes.ofHex('00');

	public function new(host: String = '127.0.0.1', port: Int) {
		var prefix: Bytes = Bytes.ofHex('0419');
		var postfix: Bytes = Bytes.ofHex('5542');
		super(host, port, prefix, [Bytes.ofHex('53'), postfix].joinBytes(), prefix, [Bytes.ofHex('50'), postfix]);
	}

	public function subscribe(): Void {
		socket.sendBytes(SUBSCRIBE_CODE);
		listenData();
	}

	private function listenData(): Void {
		socket.setTaskb(SUBJECT_CODE, 1);
	}

}