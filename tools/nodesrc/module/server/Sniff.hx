package module.server;

import haxe.io.Bytes;
import haxe.io.BytesInput;
import haxe.io.BytesOutput;

import pony.Logable;
import pony.net.ISocketClient;
import pony.net.SocketClient;
import pony.net.SocketServer;

import types.SniffConfig;

/**
 * Sniff submodule
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict) @:final class Sniff extends Logable {

	private var cfg: SniffConfig;
	private var server: SocketServer;

	public function new(cfg: SniffConfig) {
		super();
		this.cfg = cfg;
		server = new SocketServer(cfg.serverPort, false);
		server.onConnect << socketServerConnectHandler;
	}

	public function init(): Void log('Sniff ' + Std.string(cfg));

	private function socketServerConnectHandler(a: ISocketClient): Void {
		log('>> Connect');
		a.logInputData = true;
		listenErrorAndLog(a, '>>');
		var b: SocketClient = new SocketClient(cfg.clientHost, cfg.clientPort, -1, 0, false);
		b.logInputData = true;
		listenErrorAndLog(b, '<<');
		b.onOpen < b.sendAllStack;
		a.onData << convertAndSend.bind(b);
		b.onData << convertAndSend.bind(a);
		a.onDisconnect < b.destroy;
		b.onDisconnect < a.destroy;
	}

	private function convertAndSend(client: ISocketClient, bi: BytesInput): Void client.send(convertBytes(bi));

	private inline function convertBytes(bi: BytesInput): BytesOutput {
		var bo: BytesOutput = new BytesOutput();
		var bt: Bytes = bi.readAll();
		bo.write(bt);
		return bo;
	}

}