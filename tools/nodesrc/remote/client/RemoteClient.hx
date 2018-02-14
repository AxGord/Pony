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