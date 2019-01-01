package module;

import hxbit.Serializer;
import types.BAConfig;
import sys.io.Process;
import pony.net.SocketServer;
import pony.net.SocketClient;
import pony.time.DeltaTime;

/**
 * NModule
 * @author AxGord <axgord@gmail.com>
 */
class NModule<T:BAConfig> extends CfgModule<T> {

	private static var server:SocketServer;
	private static var protocol:NProtocol;
	private static var process:Process;
	private static var port:Int = Utils.NPORT;

	@:extern private static inline function initServer():Void {
		if (server != null) return;
		while (true) {
			try {
				server = new SocketServer(port);
				break;
			} catch (_:Any) {
				port++;
			}
		}
		protocol = new NProtocol(server);
	}

	override private function run(cfg:Array<T>):Void {
		listenServer();
		if (server.clients.length == 0) {
			server.onConnect < writeCfg.bind(protocol, cfg);
			runProcess();
		} else {
			writeCfg(protocol, cfg);
		}
		
	}
	
	private function listenServer():Void {
		initServer();
		server.onLog << eLog;
		server.onError << eError;
		// server.onDisconnect < unlistenServer;
		// server.onDisconnect < finishCurrentRun;
		protocol.log.onLog << eLog;
		protocol.log.onError << eError;
		// protocol.onFinish < finishHandler;
		protocol.onFinish < unlistenServer;
		protocol.onFinish < finishCurrentRun;
	}

	private function unlistenServer():Void {
		server.onLog >> eLog;
		server.onError >> eError;
		protocol.log.onLog >> eLog;
		protocol.log.onError >> eError;
	}

	private function runProcess():Void {
		if (process != null) return;
		process = Utils.asyncRunNode('pony', [Std.string(port)]);
		Module.onEndQueue < finishHandler;
	}

	private function finishHandler():Void {
		process.kill();
		process = null;
		// log('Finish process');
	}

	@:abstract private function writeCfg(protol:NProtocol, cfg:Array<T>):Void;

}