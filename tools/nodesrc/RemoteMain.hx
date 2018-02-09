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
import haxe.io.Bytes;
import haxe.xml.Fast;
import haxe.Json;
import js.Node;
import js.node.ChildProcess;
import js.node.http.IncomingMessage;
import js.node.http.ServerResponse;
import pony.net.http.HttpServer;
import pony.net.http.IHttpConnection;
import pony.NPM;
import pony.Logable;
import pony.text.XmlConfigReader;
import pony.sys.Process;
import sys.FileSystem;
import types.RemoteConfig;

/**
 * RemoteMain
 * @author AxGord <axgord@gmail.com>
 */
class RemoteMain {

	var commands:Array<RemoteCommand>;
	var protocol:RemoteProtocol;

	function new() {

		var args = Sys.args();
		if (args[0] == 'create') {
			var urla = args[1].split('@');
			var key:String = null;
			var url:Array<String> = null;
			if (urla.length > 1) {
				key = urla[0];
				url = urla[1].split(':');
			} else {
				url = urla[0].split(':');
			}
			var host:String = url[0];
			var port:Int = url.length > 1 ? Std.parseInt(url[1]) : null;
			var cl = new pony.net.SocketClient(host, port);
			protocol = new RemoteProtocol(cl);
			protocol.log.onLog << remoteLogHandler;
			protocol.onReady << function() {
				protocol.file.enable();
				protocol.file.stream.onStreamData << streamDataHandler;
				protocol.file.stream.onStreamEnd << protocol.socket.destroy;
				protocol.file.stream.onError << error;
				protocol.getInitFileRemote();
			}
			if (key != null) {
				protocol.authRemote(key);
			}
			return;
		}

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

		if (reader.cfg.host == null || reader.cfg.port == null) {
			Sys.println('Not setted port or host');
			return;
		}
		
		commands = reader.cfg.commands;

		var cl = new pony.net.SocketClient(reader.cfg.host, reader.cfg.port);
		cl.onDisconnect < disconnectHandler;
		protocol = new RemoteProtocol(cl);
		protocol.log.onLog << logHandler;
		protocol.onReady << readyHandler;
		protocol.onZipLog << zipLogHandler;

		if (reader.cfg.key != null) {
			protocol.authRemote(reader.cfg.key);
		}

	}
	
	private function disconnectHandler():Void {
		Sys.println('Disconnect');
		end(2);
	}
	
	private function readyHandler():Void {
		var runner = new RemoteActionRunner(protocol, commands);
		runner.onLog << logHandler;
		runner.onError << errorHandler;
		runner.onEnd = actionsEndHandler;
	}

	private function actionsEndHandler():Void {
		end(0);
	}

	private function logHandler(message:String, pos:haxe.PosInfos):Void {
		haxe.Log.trace(message, pos);
	}

	private function errorHandler(message:String, pos:haxe.PosInfos):Void {
		Sys.println(message);
		end(1);
	}

	private function error():Void {
		Sys.println('Error');
		end(1);
	}

	private function streamDataHandler():Void {
		Sys.print('.');
	}

	function remoteLogHandler(s:String):Void {
		for (e in s.split('\n')) if (e != null) Sys.println('| $e');
	}

	function end(code:Int = 0):Void {
		protocol.socket.onDisconnect >> disconnectHandler;
		protocol.socket.destroy();
		if (code > 0) Sys.exit(code);
	}

	function zipLogHandler(b:Bytes):Void {
		//File.saveBytes('log.txt', haxe.zip.Uncompress.run(b));
		File.saveBytes('log.txt', b);
	}

	static function main():Void {
		NPM.source_map_support.install();
		new RemoteMain();
	}

}

private class RemoteConfigReader extends XmlConfigReader<RemoteConfig> {

	override private function readNode(xml:Fast):Void {
		switch xml.name {
			case 'host': cfg.host = StringTools.trim(xml.innerData);
			case 'port': cfg.port = Std.parseInt(xml.innerData);
			case 'key': cfg.key = StringTools.trim(xml.innerData);

			case 'get': cfg.commands.push(Get(StringTools.trim(xml.innerData)));
			case 'send': cfg.commands.push(Send(StringTools.trim(xml.innerData)));
			case 'exec': cfg.commands.push(Exec(StringTools.trim(xml.innerData)));
			case 'command': cfg.commands.push(Command(StringTools.trim(xml.innerData)));

			case _: super.readNode(xml);
		}
	}

}

private class RemoteActionRunner extends Logable {

	public var onEnd:Void->Void;
	private var protocol:RemoteProtocol;
	private var commands:Array<RemoteCommand>;

	public function new(protocol:RemoteProtocol, commands:Array<RemoteCommand>) {
		super();
		this.protocol = protocol;
		this.commands = commands;
	}

	public function run():Void runNext();

	private function runNext():Void {
		if (commands.length > 0) {
			switch commands.shift() {
				case Get(file): listen(new RemoteActionGet(protocol, file));
				case Send(file): listen(new RemoteActionSend(protocol, file));
				case Exec(command): listen(new RemoteActionExec(protocol, command));
				case Command(command): listen(new RemoteActionCommand(protocol, command));
			}
		} else {
			onEnd();
		}
	}

	private function listen(action:RemoteAction):Void {
		action.onLog << log;
		action.onError << error;
		action.onEnd = runNext;
	}

}

private class RemoteAction extends Logable implements pony.magic.HasAbstract {

	private var protocol:RemoteProtocol;
	public var onEnd:Void->Void;

	public function new(protocol:RemoteProtocol, data:String) {
		super();
		this.protocol = protocol;
		run(data);
	}

	@:abstract private function run(data:String):Void {
		log(Type.getClassName(Type.getClass(this)) + ': ' + data);
	}

	public function end():Void {
		onEnd();
		destroy();
	}

	public function destroy():Void {
		destroySignals();
	}

}

private class RemoteActionGet extends RemoteAction {

	override private function run(data:String):Void {
		super.run(data);
		protocol.file.enable();
		protocol.file.stream.onStreamEnd < end;
		protocol.file.stream.onStreamData << streamDataHandler;
		protocol.file.stream.onError << streamErrorHandler;
		protocol.getFileRemote(data);
	}

	private function streamErrorHandler():Void error('File stream error');

	private function streamDataHandler():Void Sys.print('.');

	override public function destroy():Void {
		super.destroy();
		protocol.file.disable();
		protocol.file.stream.onStreamEnd >> end;
		protocol.file.stream.onStreamData >> streamDataHandler;
		protocol.file.stream.onError >> streamErrorHandler;
	}

}

private class RemoteActionSend extends RemoteAction {

	override private function run(data:String):Void {
		super.run(data);
		protocol.file.stream.onComplete < end;
		protocol.file.stream.onGetData << streamDataHandler;
		protocol.file.stream.onCancel << streamErrorHandler;
		protocol.file.sendFile(data);
	}

	private function streamErrorHandler():Void error('File stream error');

	private function streamDataHandler():Void Sys.print('.');

	override public function destroy():Void {
		super.destroy();
		protocol.file.stream.onComplete >> end;
		protocol.file.stream.onGetData >> streamDataHandler;
		protocol.file.stream.onCancel >> streamErrorHandler;
	}

}

private class RemoteActionExec extends RemoteAction {

	private var process:Process;

	override private function run(data:String):Void {
		super.run(data);
		process = new Process(data);
		process.onComplete < end;
		process.onError < error;
		process.onLog << log;
		process.run();
	}

	override public function destroy():Void {
		super.destroy();
		process.destroy();
		process = null;
	}

}

private class RemoteActionCommand extends RemoteAction {

	override private function run(data:String):Void {
		super.run(data);
		protocol.onCommandComplete < end;
		protocol.commandRemote(data);
	}

	override public function destroy():Void {
		super.destroy();
		protocol.onCommandComplete >> end;
	}

}
#end