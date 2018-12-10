/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package module;

import hxbit.Serializer;
import types.BAConfig;
import sys.io.Process;
import pony.net.SocketServer;
import pony.net.SocketClient;
import pony.time.DeltaTime;

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
		process = Utils.asyncRunNode('pony' ,[Std.string(port)]);
		Module.onEndQueue < finishHandler;
	}

	private function finishHandler():Void {
		process.kill();
		process = null;
		// log('Finish process');
	}

	@:abstract private function writeCfg(protol:NProtocol, cfg:Array<T>):Void;

}