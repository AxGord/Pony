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
import js.node.ChildProcess;
import sys.io.File;
import haxe.io.BytesOutput;
import pony.net.SocketClient;
import pony.Pair;

/**
 * ServerRemoteInstanse
 * @author AxGord <axgord@gmail.com>
 */
class ServerRemoteInstanse {

	private var client:SocketClient;
	private var currentCommand:String;
	private var key:String;
	private var protocol:RemoteProtocol;
	private var commands:Map<String, Array<Pair<Bool, String>>> = new Map();
	private var zipRLog:Bool = true;
	private var packLog:BytesOutput;
	private var needKick:Bool = false;

	public function new(client:SocketClient, key:String, commands:Map<String, Array<Pair<Bool, String>>>) {
		this.client = client;
		this.key = key;
		this.commands = commands;
		client.onClose < closeHandler;
		client.onData << dataHandler;
		protocol = new RemoteProtocol(client);
		pony.time.Timer.repeat(10000, repeatHandler);
		if (key == null) {
			start();
		} else {
			protocol.onAuth < authHandler;
		}
	}

	private function dataHandler():Void needKick = false;

	private function repeatHandler():Void {
		if (needKick) {
			client.destroy();
		} else {
			needKick = true;
		}
	}

	private function closeHandler():Void {
		Sys.println('Disconnect');
		protocol.file.cancel();
	}

	private function authHandler(v:String):Void {
		if (v == key) {
			log('Auth success');
			start();
		} else {
			log('Auth failed');
			pony.time.DeltaTime.skipUpdate(client.destroy);
		}
	}

	private function start():Void {
		protocol.file.enable();
		protocol.file.onData << function() Sys.print('.');
		protocol.onCommand << commandHandler;
		protocol.onGetInitFile << getInitFileHandler;
		protocol.readyRemote();
	}

	private function getInitFileHandler():Void {
		var file = 'init.zip';
		Sys.println('Send file: $file');
		protocol.file.sendFile(file);
	}

	private function log(s:String):Void {
		needKick = false;
		Sys.println(s);
		protocol.log.log(s);
	}

	private function prlog(s:String):Void {
		needKick = false;
		Sys.println(s);
		if (zipRLog)
			packLog.writeString(s + '\n');
		else
			protocol.log.log(s);
	}

	private function commandHandler(command:String):Void {
		Sys.println('');
		packLog = new BytesOutput();
		currentCommand = command;
		var c:Array<Pair<Bool, String>> = commands[command];
		if (c == null) {
			childExitHandler(404);
			return;
		}
		log(c[0].b);
		zipRLog = c[0].a;
		var p = ChildProcess.exec(c[0].b, execHandler);
		p.stdout.on('data', prlog);
		p.stderr.on('data', prlog);
		p.on('exit', childExitHandler);
	}

	private function execHandler(err:Null<ChildProcessExecError>, a1:String, a2:String):Void {
		//log('haxe server is exec');
	}

	private function childExitHandler(code:Int):Void {
		needKick = false;
		if (zipRLog) {
			packLog.flush();
			//protocol.zipLogRemote(haxe.zip.Compress.run(packLog.getBytes(), 9));
			protocol.zipLogRemote(packLog.getBytes());
		}
		//log('Child exited with code $code');
		protocol.commandCompleteRemote(currentCommand, code);
	}

}
#end