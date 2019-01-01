package remote.client;

import sys.io.File;
import haxe.io.Bytes;
import types.RemoteConfig;

/**
 * Remote Client
 * @author AxGord <axgord@gmail.com>
 */
class RemoteClient {

	private var commands:Array<RemoteCommand>;
	private var protocol:RemoteProtocol;

	public function new(args:Array<String>) {
		var cfg = Utils.parseArgs(args);
		var xml = Utils.getXml();

		var reader = new RemoteConfigReader(xml.node.remote, {
			app: cfg.app,
			debug: cfg.debug,
			host: null,
			port: null,
			key: null,
			commands: []
		});
		
		commands = reader.cfg.commands;

		protocol = RemoteClientMain.createProtocol(reader.cfg.host, reader.cfg.port, reader.cfg.key);
		protocol.log.onLog << logHandler;
		protocol.onReady < readyHandler;
		protocol.onZipLog << zipLogHandler;
	}
	
	private function readyHandler():Void {
		var runner = new RemoteActionRunner(protocol, commands);
		runner.onLog << logHandler;
		runner.onError << errorHandler;
		runner.onEnd = actionsEndHandler;
	}

	private function actionsEndHandler():Void end(0);

	private function logHandler(message:String, pos:haxe.PosInfos):Void {
		haxe.Log.trace(message, pos);
	}

	private function errorHandler(message:String, pos:haxe.PosInfos):Void {
		Sys.println(message);
		end(3);
	}

	private function end(code:Int = 0):Void {
		protocol.socket.onDisconnect >> RemoteClientMain.disconnectHandler;
		protocol.socket.destroy();
		if (code > 0) Sys.exit(code);
	}

	private function zipLogHandler(b:Bytes):Void {
		//File.saveBytes('log.txt', haxe.zip.Uncompress.run(b));
		File.saveBytes('log.txt', b);
	}

}