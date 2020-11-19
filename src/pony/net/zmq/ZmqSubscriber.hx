package pony.net.zmq;

import haxe.Int64;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.events.Signal2;

using pony.Tools;

/**
 * ZeroMQ Subscriber
 * @author AxGord <axgord@gmail.com>
 */
class ZmqSubscriber extends ZmqBase {

	private static var SUBSCRIBE_CODE: Bytes = Bytes.ofHex('000101');

	@:auto public var onData: Signal2<BytesInput, BytesInput>;

	private var stack: Array<Bytes> = [];
	private var currentSubject: BytesInput;

	public function new(host: String = '127.0.0.1', port: Int) {
		var prefix: Bytes = Bytes.ofHex('0419');
		var postfix: Bytes = Bytes.ofHex('5542');
		super(host, port, prefix, [Bytes.ofHex('53'), postfix].joinBytes(), prefix, [Bytes.ofHex('50'), postfix].joinBytes());
		onOpen < openHandler;
		onOpen < listenData;
	}

	public function subscribe(): Void {
		sendBytes(SUBSCRIBE_CODE);
	}

	private function openHandler(): Void {
		for (bo in stack) socket.sendBytes(bo);
		stack = [];
	}

	private function sendBytes(b: Bytes): Void {
		if (opened)
			socket.sendBytes(SUBSCRIBE_CODE);
		else
			stack.push(b);
	}

	private function listenData(): Void {
		socket.setTask(1) < subjectDataHandler;
	}

	private function subjectDataHandler(bi: BytesInput): Void {
		switch bi.readByte() {
			case 0x01: socket.setTask(1) < subjectSmallReadSizeHandler;
			case 0x03: socket.setTask(8) < subjectBigReadSizeHandler;
			case _: fatal('subject');
		}
	}

	private function subjectSmallReadSizeHandler(bi: BytesInput): Void listenSubject(bi.readByte());

	private function subjectBigReadSizeHandler(bi: BytesInput): Void {
		bi.bigEndian = true;
		listenSubject(Int64.make(bi.readInt32(), bi.readInt32()));
	}

	private inline function listenSubject(len: Int64): Void socket.setTask(len) < subjectHandler;

	private function subjectHandler(bi: BytesInput): Void {
		currentSubject = bi;
		socket.setTask(1) < contentDataHandler;
	}

	private function contentDataHandler(bi: BytesInput): Void {
		switch bi.readByte() {
			case 0x00: socket.setTask(1) < contentSmallReadSizeHandler;
			case 0x02: socket.setTask(8) < contentBigReadSizeHandler;
			case _: fatal('content');
		}
	}

	private function contentSmallReadSizeHandler(bi: BytesInput): Void listenContent(bi.readByte());

	private function contentBigReadSizeHandler(bi: BytesInput): Void {
		bi.bigEndian = true;
		listenContent(Int64.make(bi.readInt32(), bi.readInt32()));
	}

	private inline function listenContent(len: Int64): Void socket.setTask(len) < contentHandler;

	private function contentHandler(bi: BytesInput): Void {
		eData.dispatch(currentSubject, bi);
		currentSubject = null;
		listenData();
	}

}