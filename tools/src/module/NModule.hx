package module;

import pony.net.SocketServer;
import pony.time.DTimer;

import sys.io.Process;

import types.BAConfig;

/**
 * NModule
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
#if (haxe_ver >= 4.2) abstract #end
class NModule<T:BAConfig> extends CfgModule<T> {

	private static var PORT_TRIES: Int = 1000;
	private static var NODE_PATH: String = 'NODE_PATH';

	private static var server: Null<SocketServer>;
	private static var protocol: Null<NProtocol>;
	private static var process: Null<Process>;
	private static var port: Int = Utils.NPORT;
	private static var timeout: DTimer = DTimer.createFixedTimer(60000);

	@SuppressWarnings('checkstyle:MagicNumber')
	#if (haxe_ver >= 4.2) extern #else @:extern #end
	private static inline function initServer(): Void {
		if (server != null) return;
		timeout.complete << Utils.error.bind('Timeout');
		var n: Int = 0;
		while (true) {
			try {
				server = new SocketServer(port);
				break;
			} catch (_: Any) {
				if (n++ > PORT_TRIES) Utils.error('Can\'t create socket server');
				port++;
			}
		}
		protocol = @:nullSafety(Off) new NProtocol(server);
	}

	@:nullSafety(Off) override private function run(cfg: Array<T>): Void {
		listenServer();
		if (server.clients.length == 0) {
			server.onConnect < writeCfg.bind(protocol, cfg);
			runProcess();
		} else {
			writeCfg(protocol, cfg);
		}

	}

	@:nullSafety(Off) private function listenServer(): Void {
		initServer();
		server.onData < timeout.stop;
		listenErrorAndLog(server);
		// server.onDisconnect < unlistenServer;
		// server.onDisconnect < finishCurrentRun;
		listenErrorAndLog(protocol.log);
		// protocol.onFinish < finishHandler;
		protocol.onFinish < unlistenServer;
		protocol.onFinish < finishCurrentRun;
	}

	@:nullSafety(Off) private function unlistenServer(): Void {
		server.onLog >> eLog;
		server.onError >> eError;
		protocol.log.onLog >> eLog;
		protocol.log.onError >> eError;
	}

	private function runProcess():Void {
		if (process != null) return;
		timeout.reset();
		timeout.start();
		var env: Null<String> = Sys.getEnv(NODE_PATH);
		if (env == null) {
			env = new Process('npm', ['root', '-g']).stdout.readLine();
			Sys.putEnv(NODE_PATH, env);
		}
		process = Utils.asyncRunNode('pony', [Std.string(port)]);
		Module.onEndQueue < finishHandler;
	}

	private function finishHandler(): Void {
		@:nullSafety(Off) process.kill();
		process = null;
		// log('Finish process');
	}

	@:abstract private function writeCfg(protol: NProtocol, cfg: Array<T>): Void;

}