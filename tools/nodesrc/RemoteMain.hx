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
import pony.text.XmlConfigReader;
import sys.FileSystem;

typedef RemoteConfig = { > BaseConfig,
	key: String,
	files: Array<String>,
	commands: Array<String>
}

/**
 * RemoteMain
 * @author AxGord <axgord@gmail.com>
 */
class RemoteMain {

	var fileq:Array<String> = [];
	var commands:Array<String>;
	var protocol:RemoteProtocol;

	function new() {

		var cfg = Utils.parseArgs(Sys.args());
		var xml = Utils.getXml();
		
		var rx = xml.node.remote;

		var reader = new RemoteConfigReader(rx, {
			app: cfg.app,
			debug: cfg.debug,
			key: null,
			files: [],
			commands: []
		});
		
		commands = reader.cfg.commands;
		fileq = reader.cfg.files;

		var cl = new pony.net.SocketClient(rx.node.host.innerData, Std.parseInt(rx.node.port.innerData));
		protocol = new RemoteProtocol(cl);
		protocol.log.onLog << logHandler;
		protocol.onCommandComplete << commandCompleteHandler;
		protocol.onReady << readyHandler;

		if (reader.cfg.key != null) {
			protocol.authRemote(reader.cfg.key);
		}

	}

	private function readyHandler():Void {
		if (fileq.length == 0) {
			runCommands();
		} else {
			protocol.file.stream.onGetData << streamDataHandler;
			protocol.file.stream.onComplete << sendNextFile;
			protocol.file.stream.onCancel << error;
			sendNextFile();
		}
	}

	private function error():Void {
		Sys.println('Error');
		end();
	}

	private function streamDataHandler():Void {
		Sys.print('.');
	}

	private function sendNextFile():Void {
		Sys.println('');
		if (fileq.length == 0) {
			runCommands();
		} else {
			var file:String = fileq.shift();
			Sys.println('Send file: $file');
			protocol.file.sendFile(file);
		}
	}

	function commandCompleteHandler(name:String, code:Int):Void {
		if (code == 0) {
			runCommands();
		} else {
			Sys.println('End with error $code');
			end(code);
		}
	}

	function logHandler(s:String):Void {
		for (e in s.split('\n')) if (e != null) Sys.println('| $e');
	}

	function runCommands():Void {
		if (commands.length > 0) {
			protocol.commandRemote(commands.shift());
		} else {
			end();
		}
	}

	function end(code:Int = 0):Void {
		protocol.socket.destroy();
		Sys.exit(code);
	}

	static function main():Void {
		NPM.source_map_support.install();
		new RemoteMain();
	}

}

private class RemoteConfigReader extends XmlConfigReader<RemoteConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'key': cfg.key = StringTools.trim(xml.innerData);
			case 'send': cfg.files.push(StringTools.trim(xml.innerData));
			case 'command': cfg.commands.push(StringTools.trim(xml.innerData));
			case _: super.readNode(xml);
		}
	}

}
#end