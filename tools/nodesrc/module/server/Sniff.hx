package module.server;

import haxe.io.Bytes;
import haxe.io.BytesOutput;
import haxe.io.BytesInput;
import pony.net.SocketClient;
import pony.net.SocketServer;
import pony.Logable;
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
		listenErrorAndLog(server, '>>');
		server.onConnect << socketServerConnectHandler;
	}

	public function init(): Void log('Sniff ' + Std.string(cfg));

	private function socketServerConnectHandler(a: SocketClient): Void {
		var b: SocketClient = new SocketClient(cfg.clientHost, cfg.clientPort, -1, 0, false);
		listenErrorAndLog(b, '<<');
		b.onOpen < b.sendAllStack;
		a.onData << convertAndSend.bind(b);
		b.onData << convertAndSend.bind(a);
		a.onDisconnect < b.destroy;
		b.onDisconnect < a.destroy;
	}

	private function convertAndSend(client: SocketClient, bi: BytesInput): Void client.send(convertBytes(bi));

	private inline function convertBytes(bi: BytesInput): BytesOutput {
		var bo: BytesOutput = new BytesOutput();
		var bt: Bytes = bi.readAll();
		bo.write(bt);
		return bo;
	}

}