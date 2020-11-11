package pony.net.neko;

#if neko
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Error;
import haxe.io.Eof;
import sys.net.Socket;
import sys.net.Host;
import pony.net.SocketClientBase;
import pony.time.DeltaTime;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class SocketClient extends SocketClientBase {

	private var socket: Socket;
	private var buffer: BytesOutput;
	private var q: Queue<BytesOutput -> Void>;

	override public function open(): Void {
		super.open();
		socket = new Socket();
		socket.connect(new Host(host), port);
		_init();
	}

	private function _init(): Void {
		q = new Queue(_send);
		socket.setBlocking(false);
		buffer = new BytesOutput();
		DeltaTime.fixedUpdate < connect;
		DeltaTime.fixedUpdate << updateHandler;
	}

	@:allow(pony.net.neko.SocketServer)
	private function nekoInit(client: Socket): Void {
		socket = client;
		_init();
	}

	private function updateHandler(): Void {
		try {
			while (true) buffer.writeByte(socket.input.readByte());
		} catch (e:Error) {
			if (e != Error.Blocked)
				error(e.getName());
			else
				processBuffer();
		} catch (e:Eof) {
			log('eof');
			processBuffer();
			close();
		} catch (e:Any) {
			error(e);
		}
	}

	private function processBuffer(): Void {
		if (buffer.length > readLengthSize) {
			joinData(new BytesInput(buffer.getBytes()));
			buffer.flush();
			buffer = new BytesOutput();
		} else if (buffer.length > 0) {
			buffer.flush();
			buffer = new BytesOutput();
		}
	}

	private function closeHandler(_): Void close();
	public function send(data: BytesOutput): Void q.call(data);

	private function _send(data: BytesOutput): Void {
		try {
			socket.output.write(data.getBytes());
			socket.output.flush();
		} catch (e:Dynamic) {
			error(e);
		}
		DeltaTime.fixedUpdate < q.next;
	}

	override public function close(): Void {
		DeltaTime.fixedUpdate >> updateHandler;
		super.close();
		try {
			socket.close();
		} catch (_: Dynamic) {}
	}

}
#end