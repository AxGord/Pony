package remote.client;

import pony.NPM;

/**
 * Remote Client Main
 * @author AxGord <axgord@gmail.com>
 */
class RemoteClientMain {

	private static function main():Void {
		NPM.source_map_support.install();
		var args = Sys.args();
		if (!new RemoteClientCreate(args).runned) new RemoteClient(args);
	}

	public static function createProtocol(host:String, port:Int, key:String):RemoteProtocol {
		if (host == null || port == null) {
			Sys.println('Not setted port or host');
			Sys.exit(1);
		}
		var client = new pony.net.SocketClient(host, port);
		client.onDisconnect < disconnectHandler;		
		var protocol = new RemoteProtocol(client);
		if (key != null) protocol.authRemote(key);
		return protocol;
	}

	public static function disconnectHandler():Void {
		Sys.println('Disconnect');
		Sys.exit(2);
	}

}