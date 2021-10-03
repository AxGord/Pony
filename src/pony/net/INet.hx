package pony.net;

import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;

/**
 * INet
 * @author DIS
 * @author AxGord <axgord@gmail.com>
 */
interface INet {

	/**
	 * onAccept in a server
	 */
	var onConnect(get, null): Signal1<SocketClient>;

	var onOpen(get, null): Signal0;

	var onData(get, null): Signal2<BytesInput, SocketClient>;
	var onString(get, null): Signal2<String, SocketClient>;

	var onClose(get, null): Signal0;
	var onDisconnect(get, null): Signal1<SocketClient>;

	var opened(default, null): Bool;

	var isWithLength: Bool;

	function send(b: BytesOutput): Void;
	function sendString(s: String): Void;
	function destroy(): Void;

}