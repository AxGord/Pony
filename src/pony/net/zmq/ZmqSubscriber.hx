package pony.net.zmq;

import haxe.Int64;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.events.Event2;
import pony.events.Signal2;

using pony.Tools;

/**
 * ZeroMQ Subscriber
 * @author AxGord <axgord@gmail.com>
 */
class ZmqSubscriber extends ZmqBase {

	private static inline var SUBSCRIBE_CODE: Int = 0x01;
	private static inline var UNSUBSCRIBE_CODE: Int = 0x00;

	@:auto public var onData: Signal2<String, BytesInput>;

	private var currentSubject: String;
	private var subscribes: Map<String, Event2<String, BytesInput>> = new Map<String, Event2<String, BytesInput>>();

	public function new(host: String = '127.0.0.1', port: Int) {
		var prefix: Bytes = Bytes.ofHex('0419');
		var postfix: Bytes = Bytes.ofHex('5542');
		super(host, port, prefix, [Bytes.ofHex('53'), postfix].joinBytes(), prefix, [Bytes.ofHex('50'), postfix].joinBytes());
		onOpen < listenData;
	}

	public function subscribe(subject: String = ''): Signal2<String, BytesInput> {
		if (subscribes.exists(subject)) return subscribes[subject];
		var bo: BytesOutput = new BytesOutput();
		bo.writeByte(SUBSCRIBE_CODE);
		bo.writeString(subject);
		_send(bo);
		var event: Event2<String, BytesInput> = new Event2<String, BytesInput>();
		function dataHandler(s: String, b: BytesInput): Void if (s.substr(0, subject.length) == subject) event.dispatch(s, b);
		event.onTake << function(): Void onData << dataHandler;
		event.onLost << function(): Void onData >> dataHandler;
		subscribes[subject] = event;
		return event;
	}

	public function unsubscribe(subject: String = ''): Void {
		if (!subscribes.exists(subject)) return;
		subscribes[subject].destroy();
		subscribes.remove(subject);
		var bo: BytesOutput = new BytesOutput();
		bo.writeByte(UNSUBSCRIBE_CODE);
		bo.writeString(subject);
		_send(bo);
	}

	private function listenData(): Void socket.setTask(1) < subjectDataHandler;

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
		currentSubject = bi.readAll().toString();
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