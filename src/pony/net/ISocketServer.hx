package pony.net;

import haxe.io.BytesOutput;

/**
 * ISocketServer
 * @author AxGord <axgord@gmail.com>
 */
interface ISocketServer extends INet {

	var isAbleToSend: Bool;
	var clients(default, null): Array<SocketClient>;

	function send2other(data: BytesOutput, exception: SocketClient): Void;

}