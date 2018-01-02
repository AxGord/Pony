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
import pony.net.SocketClient;

/**
 * ServerRemoteInstanse
 * @author AxGord <axgord@gmail.com>
 */
class ServerRemoteInstanse {

	private var currentCommand:String;
	private var key:String;
	private var protocol:RemoteProtocol;
	private var commands:Map<String, Array<String>> = new Map();

	public function new(client:SocketClient, key:String, commands:Map<String, Array<String>>) {
		this.key = key;
		this.commands = commands;
		protocol = new RemoteProtocol(client);
		if (key == null)
			start();
		else
			protocol.onAuth < authHandler;
	}

	private function authHandler(v:String):Void {
		if (v == key) {
			log('Auth success');
			start();
		} else {
			log('Auth failed');
			pony.time.DeltaTime.skipUpdate(protocol.socket.destroy);
		}
	}

	private function start():Void {
		protocol.onFile << fileHandler;
		protocol.onCommand << commandHandler;
	}

	private function fileHandler(name:String, data:haxe.io.Bytes):Void {
		log('Get file: $name (' + data.length + ')');
		File.saveBytes(name, data);
		protocol.fileReceivedRemote(name);
	}

	private function log(s:String):Void {
		Sys.println(s);
		protocol.logRemote(s);
	}

	private function commandHandler(command:String):Void {
		currentCommand = command;
		var c:Array<String> = commands[command];
		if (c == null) {
			childExitHandler(404);
			return;
		}
		log(c[0]);
		var p = ChildProcess.exec(c[0], execHandler);
		p.stdout.on('data', log);
		p.stderr.on('data', log);
		p.on('exit', childExitHandler);
	}

	private function execHandler(err:Null<ChildProcessExecError>, a1:String, a2:String):Void {
		//log('haxe server is exec');
	}

	private function childExitHandler(code:Int):Void {
		//log('Child exited with code $code');
		protocol.commandCompleteRemote(currentCommand, code);
	}

}
#end