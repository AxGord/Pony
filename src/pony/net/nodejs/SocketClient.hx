package pony.net.nodejs;

#if nodejs
import js.Node;
import js.node.Buffer;
import js.node.Net;
import js.node.net.Socket;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import pony.Queue;
import pony.net.SocketClientBase;
import pony.time.DeltaTime;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) class SocketClient extends SocketClientBase {

	#if !nodedt
	private static var SEND_TIMEOUT: Int = Std.int(1000 / 60);
	#end

	private var socket: Null<Socket>;
	@:nullSafety(Off) private var q: Queue<BytesOutput -> Void>;

	override private function open(): Void {
		super.open();
		var s: Socket = Net.createConnection(port, host);
		s.on('connect', connect);
		nodejsInit(s);
	}

	@:allow(pony.net.nodejs.SocketServer)
	private function nodejsInit(s: Socket): Void {
		q = new Queue(_send);
		socket = s;
		s.on('data', dataHandler);
		s.on('end', close);
		s.on('error', error.bind('socket error'));
	}

	override private function close(): Void {
		super.close();
		if (socket != null) {
			socket.end();
			@:nullSafety(Off) socket.destroy();
			socket = null;
		}
	}

	public function send(data: BytesOutput): Void q.call(data);

	private function _send(data: BytesOutput): Void {
		if (socket == null) return;
		var b: Bytes = data.getBytes();
		logBytes('Send data', b);
		@:nullSafety(Off) socket.write(Buffer.hxFromBytes(b), sendNextAfterTimeout);
	}

	#if nodedt
	private function sendNextAfterTimeout(): Void DeltaTime.skipUpdate(q.next);
	#else
	private function sendNextAfterTimeout(): Void Node.setTimeout(q.next, SEND_TIMEOUT);
	#end

	private function dataHandler(d: Buffer): Void joinData(new BytesInput(Bytes.ofData(d.buffer)));

}
#end