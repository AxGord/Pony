package pony.net.flash;

#if flash
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.net.SocketClientBase;
import pony.time.DeltaTime;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class SocketClient extends SocketClientBase {

	private var socket: Socket;
	private var q: Queue<BytesOutput -> Void>;

	override public function open(): Void {
		super.open();
		q = new Queue(_send);
		socket = new Socket(host, port);
		socket.addEventListener(Event.CONNECT, connectHandler);
		socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
		socket.addEventListener(Event.CLOSE, closeHandler);
		socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
	}

	// private function skipOutputProgressHandler():Void outputProgressHandler(null);

	private function outputProgressHandler(_): Void {
		socket.removeEventListener('outputProgress', outputProgressHandler);
		DeltaTime.skipUpdate(q.next);
	}

	private function securityErrorHandler(_): Void {}
	private function ioErrorHandler(event: IOErrorEvent): Void error(event.text);
	private function closeHandler(_): Void close();
	private function connectHandler(_): Void connect();
	public function send(data: BytesOutput): Void q.call(data);

	private function _send(data: BytesOutput): Void {
		socket.addEventListener('outputProgress', outputProgressHandler);
		try {
			socket.writeBytes(data.getBytes().getData());
			socket.flush();
			// DeltaTime.skipUpdate(skipOutputProgressHandler);
		} catch (e: Dynamic) {
			error(e);
		}
	}

	override public function close(): Void {
		super.close();
		try {
			socket.close();
		} catch (_: Dynamic) {}
	}

	private function socketDataHandler(_): Void {
		var b: BytesData = new BytesData();
		socket.readBytes(b);
		joinData(new BytesInput(Bytes.ofData(b)));
	}

}
#end