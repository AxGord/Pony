package pony.net;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;
import haxe.io.Bytes;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.Logable;

/**
 * SocketServerBase
 * @author AxGord <axgord@gmail.com>
 */
class SocketServerBase extends Logable {

	@:auto public var onData: Signal2<BytesInput, ISocketClient>;
	@:auto public var onString: Signal2<String, ISocketClient>;

	@:auto public var onConnect: Signal1<ISocketClient>;
	@:auto public var onOpen: Signal0;

	@:auto public var onClose: Signal0;
	@:auto public var onDisconnect: Signal1<ISocketClient>;

	public var opened(default, null): Bool;

	public var clients(default, null): Array<ISocketClient> = [];
	public var isAbleToSend: Bool = false;

	public var isWithLength: Bool = true;
	public var maxSize: Int;

	private function new() {
		super();
		eString.onTake << beginString;
		eString.onLost << endString;
		clients = [];
		onDisconnect << removeClient;
		onOpen < function() opened = true;
		onConnect < function() isAbleToSend = true;
	}

	private function beginString(): Void for (c in clients) c.onString << eString;
	private function endString(): Void for (c in clients) c.onString >> eString;

	private function addClient(): ISocketClient {
		var cl: SocketClient = Type.createEmptyInstance(SocketClient);
		@:privateAccess cl.logPrefix = '';
		listenErrorAndLog(cl);
		cl.init(cast this, clients.length);
		clients.push(cl);
		return cl;
	}

	private function removeClient(cl: ISocketClient): Void clients.remove(cl);

	/**
	 * Sends a data to all the clients.
	 */
	public function send(data: BytesOutput): Void {
		var bs: Bytes = data.getBytes();
		for (c in clients) {
			var b: BytesOutput = new BytesOutput();
			b.write(bs);
			c.send(b);
		}
	}

	/**
	 * Sends a data to all the clients except chosen one.
	 */
	public function send2other(data: BytesOutput, exception: ISocketClient): Void {
		var bs: Bytes = data.getBytes();
		for (c in clients) {
			if (c == exception) continue;
			var b: BytesOutput = new BytesOutput();
			b.write(bs);
			c.send(b);
		}
	}

	/**
	 * One should remember that a destroy function _must_ be called from a thread in which the server was created.
	 */
	override public function destroy(): Void {
		opened = false;
		super.destroy();
	}

}