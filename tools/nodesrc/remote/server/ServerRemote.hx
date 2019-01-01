package remote.server;
#if nodejs
import pony.net.SocketServer;
import pony.net.SocketClient;
import pony.Pair;
import haxe.xml.Fast;

using pony.text.XmlTools;

/**
 * ServerRemote
 * @author AxGord <axgord@gmail.com>
 */
class ServerRemote {

	private var socket:SocketServer;
	private var key:String = null;
	private var commands:Map<String, Array<Pair<Bool, String>>> = new Map();
	private var instanse:ServerRemoteInstanse;
	private var cmdLock:Bool = false;
	private var allowForGet:Array<String>;

	public function new(xml:Fast) {
		var port = Std.parseInt(xml.node.port.innerData);
		try {
			key = StringTools.trim(xml.node.key.innerData);
		} catch (_:Any) {}

		allowForGet = [for (node in xml.nodes.allow) StringTools.trim(node.innerData)];

		for (node in xml.node.commands.elements) {
			var d:Pair<Bool, String> = new Pair(!node.isFalse('zipLog'), StringTools.trim(node.innerData));
			if (!commands.exists(node.name))
				commands[node.name] = [d];
			else
				commands[node.name].push(d);
		}

		Sys.println('Remote Server running at $port');
		socket = new SocketServer(port);
		socket.onConnect << connectHandler;
	}

	private function connectHandler(client:SocketClient):Void {
		Sys.println('New connection');
		if (instanse == null && !cmdLock) {
			Sys.println('Accept');
			instanse = new ServerRemoteInstanse(client, key, commands, allowForGet);
			instanse.onBeginCommand = beginCommandHandler;
			instanse.onEndCommand = endCommandHandler;
			client.onClose < closeHandler;
		} else {
			Sys.println('Deny');
			client.destroy();
		}
	}

	private function closeHandler():Void instanse = null;

	private function beginCommandHandler():Void cmdLock = true;
	private function endCommandHandler():Void cmdLock = false;

}
#end