package pony.net;

import haxe.io.BytesInput;
import haxe.io.BytesOutput;

import pony.events.Event1;
import pony.events.Event2;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;

/**
 * INet
 * @author DIS
 * @author AxGord <axgord@gmail.com>
 */
interface INet extends ILogable {

	/**
	 * onAccept in a server
	 */
	var onConnect(get, null): Signal1<ISocketClient>;
	private var eConnect: Event1<ISocketClient>;

	var onOpen(get, null): Signal0;

	var onData(get, null): Signal2<BytesInput, ISocketClient>;
	private var eData: Event2<BytesInput, ISocketClient>;
	var onString(get, null): Signal2<String, ISocketClient>;
	private var eString: Event2<String, ISocketClient>;

	var onClose(get, null): Signal0;
	var onDisconnect(get, null): Signal1<ISocketClient>;
	private var eDisconnect: Event1<ISocketClient>;

	var opened(default, null): Bool;

	var isWithLength: Bool;

	function send(b: BytesOutput): Void;
	function sendString(s: String): Void;
	function destroy(): Void;

}