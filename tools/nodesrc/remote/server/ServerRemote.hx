package remote.server;

import types.RemoteServerConfig;
import pony.Logable;
import pony.net.SocketServer;
import pony.net.SocketClient;
import pony.Pair;

/**
 * ServerRemote
 * @author AxGord <axgord@gmail.com>
 */
class ServerRemote extends Logable {

	private var port: UInt;
	private var socket: SocketServer;
	private var key: Null<String>;
	private var commands: Map<String, Array<Pair<Bool, String>>>;
	private var instanse: ServerRemoteInstanse;
	private var cmdLock: Bool = false;
	private var allowForGet: Array<String>;

	public function new(cfg: RemoteServerConfig) {
		super();
		port = cfg.port;
		key = cfg.key;
		allowForGet = cfg.allow;
		commands = cfg.commands;
	}

	public function init(): Void {
		log('Remote Server running at ${port}');
		socket = new SocketServer(port);
		socket.onConnect << connectHandler;
	}

	private function connectHandler(client:SocketClient):Void {
		log('New connection');
		if (instanse == null && !cmdLock) {
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

	private function closeHandler():Void instanse = null;
	private function beginCommandHandler():Void cmdLock = true;
	private function endCommandHandler():Void cmdLock = false;

}