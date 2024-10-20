package remote.client;

import pony.Logable;
import pony.events.Signal1;
import pony.net.SocketClient;
import sys.io.File;
import haxe.io.Bytes;
import haxe.PosInfos;
import types.RemoteConfig;

/**
 * Remote Client
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety
#if (haxe_ver >= 4.2) final #else @:final #end
class RemoteClient extends Logable {

	@:auto public var onComplete: Signal1<Int>;

	private var cfg: RemoteConfig;
	private var commands: Array<RemoteCommand>;
	private var protocol: Null<RemoteProtocol>;

	public function new(cfg: RemoteConfig) {
		super();
		this.cfg = cfg;
		commands = cfg.commands;
	}

	public function init(): Void {
		protocol = createProtocol(cfg.host, cfg.port, cfg.key);
		if (protocol == null) return;
		protocol.log.onLog << eLog;
		protocol.onReady < readyHandler;
		protocol.onZipLog << zipLogHandler;

	}

	public function createProtocol(host: String, port: Int, key: String): Null<RemoteProtocol> {
		if (host == null || port == null) {
			error('Not setted port or host');
			eComplete.dispatch(1);
			return null;
		} else {
			var client: SocketClient = new SocketClient(host, port);
			client.onDisconnect < disconnectHandler;
			var p: RemoteProtocol = new RemoteProtocol(client);
			if (key != null) p.authRemote(key);
			return p;
		}
	}

	public function disconnectHandler(): Void {
		error('Disconnect');
		eComplete.dispatch(2);
	}

	private function readyHandler(): Void {
		if (protocol == null) return;
		var runner: RemoteActionRunner = new RemoteActionRunner(protocol, commands);
		runner.onLog << eLog;
		runner.onError << eError;
		runner.onError << errorHandler;
		runner.onEnd = actionsEndHandler;
	}

	private function actionsEndHandler(): Void end(0);
	private function errorHandler():Void end(3);

	private function end(code: Int = 0): Void {
		if (protocol != null) {
			protocol.socket.onDisconnect >> disconnectHandler;
			protocol.socket.destroy();
		}
		eComplete.dispatch(code);
	}

	private function zipLogHandler(b: Bytes): Void {
		//File.saveBytes('log.txt', haxe.zip.Uncompress.run(b));
		File.saveBytes('log.txt', b);
	}

}