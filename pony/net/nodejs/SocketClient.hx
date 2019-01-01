package pony.net.nodejs;

#if nodejs
import pony.Queue;
import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import js.Node;
import pony.net.SocketClientBase;

/**
 * SocketClient
 * @author AxGord <axgord@gmail.com>
 */
class SocketClient extends SocketClientBase {
	
	private var socket:js.node.net.Socket;
	private var q:Queue < BytesOutput -> Void > ;
	
	override private function open():Void {
		super.open();
		socket = js.node.Net.connect(port, host);
		socket.on('connect', connect);
		nodejsInit(socket);
	}
	
	@:allow(pony.net.nodejs.SocketServer)
	private function nodejsInit(s:js.node.net.Socket):Void {
		q = new Queue(_send);
		socket = s;
		s.on('data', dataHandler);
		s.on('end', close);
		s.on('error', error.bind('socket error'));
	}
	
	override private function close():Void {
		super.close();
		if (socket != null) {
			socket.end();
			socket.destroy();
			socket = null;
		}
	}
	
	#if !nodedt
	@:deprecated('Node DeltaTime not activated! Please, use nodedt flag!')
	#end
	public function send(data:BytesOutput):Void q.call(data);
	
	private function _send(data:BytesOutput):Void {
		if (socket != null) socket.write(js.node.Buffer.hxFromBytes(data.getBytes()), sendNextAfterTimeout);
	}

	private function sendNextAfterTimeout():Void {
		pony.time.DeltaTime.skipUpdate(q.next);
	}

	private function dataHandler(d:js.node.Buffer):Void joinData(new BytesInput(Bytes.ofData(d.buffer)));
	
}

#end