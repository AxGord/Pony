/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
#if nodejs
import sys.io.File;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;
import js.node.ChildProcess;
import js.node.http.IncomingMessage;
import js.node.http.ServerResponse;
import pony.net.http.HttpServer;
import pony.net.http.IHttpConnection;
import pony.NPM;
import sys.FileSystem;

/**
 * RemoteMain
 * @author AxGord <axgord@gmail.com>
 */
class RemoteMain {

	var fileq:Array<String> = [];
	var commands:Array<String>;
	var protocol:RemoteProtocol;

	function new() {
		var xml = Utils.getXml();
		
		var rx = xml.node.remote;
		
		commands = [for (c in rx.nodes.command) c.innerData];

		var cl = new pony.net.SocketClient(rx.node.host.innerData, Std.parseInt(rx.node.port.innerData));
		protocol = new RemoteProtocol(cl);
		protocol.onLog << logHandler;
		protocol.onFileReceived << fileReceivedHandler;
		protocol.onCommandComplete << runCommands;

		if (rx.nodes.send.length == 0) {
			runCommands();
		} else {
			for (send in rx.nodes.send) {
				var file = send.innerData;
				fileq.push(file);
				protocol.fileRemote(file, File.getBytes(file));
			}

		}

	}

	function logHandler(s:String):Void {
		for (e in s.split('\n')) if (e != null) Sys.println('| $e');
	}

	function fileReceivedHandler(file:String):Void {
		trace('File received: $file');
		fileq.remove(file);
		if (fileq.length == 0)
			runCommands();
	}

	function runCommands():Void {
		if (commands.length > 0) {
			pony.time.DeltaTime.fixedUpdate < protocol.commandRemote.bind(commands.shift());
		} else {
			protocol.socket.destroy();
			Sys.exit(0);
		}
	}

	static function main():Void {
		NPM.source_map_support.install();
		new RemoteMain();
	}

}
#end