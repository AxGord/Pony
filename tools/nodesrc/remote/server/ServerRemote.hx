package remote.server;

import pony.Logable;
import pony.Pair;
import pony.net.ISocketClient;
import pony.net.SocketServer;
import types.RemoteServerConfig;

/**
 * ServerRemote
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety
#if (haxe_ver >= 4.2) final #else @:final #end
class ServerRemote extends Logable {

	private final port: UInt;
	private final key: Null<String>;
	private final commands: Map<String, Array<Pair<Bool, String>>>;
	private final allowForGet: Array<String>;

	private var cmdLock: Bool = false;
	private var socket: Null<SocketServer>;
	private var instanse: Null<ServerRemoteInstanse>;

	public function new(cfg: RemoteServerConfig) {
		super();
		if (@:nullSafety(Off) (cfg.port == null)) throw 'Port not set';
		port = cast cfg.port;
		key = cfg.key;
		allowForGet = cfg.allow;
		commands = cfg.commands;
	}

	public function init(): Void {
		logf(() -> 'Remote Server running at ${port}');
		socket = new SocketServer(port);
		socket.onConnect << connectHandler;
	}

	private function connectHandler(client: ISocketClient): Void {
		log('New connection');
		if (instanse == null && !cmdLock && key != null) {
			log('Accept');
			instanse = new ServerRemoteInstanse(client, key, commands, allowForGet);
			instanse.onBeginCommand = beginCommandHandler;
			instanse.onEndCommand = endCommandHandler;
			client.onClose < closeHandler;
		} else {
			log('Deny');
			client.destroy();
		}
	}

	private function closeHandler(): Void instanse = null;

	private function beginCommandHandler(): Void cmdLock = true;

	private function endCommandHandler(): Void cmdLock = false;

}
