package pony.net;

import haxe.io.BytesOutput;

/**
 * ISocketClient
 * @author AxGord <axgord@gmail.com>
 */
interface ISocketClient extends INet {

	#if !flash

	#if (!js || nodejs)
	var server(default, null): ISocketServer;
	function send2other(data: BytesOutput): Void;
	#end

	var id(default, null): Int;
	var host(default, null): String;
	var port(default, null): Int;

	var logOutputData: Bool;
	var logInputData(default, set): Bool;

	function reconnect(): Void;

	#end

}