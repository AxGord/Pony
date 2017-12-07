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
import js.node.ChildProcess;
import haxe.xml.Fast;
import sys.io.File;
import pony.net.SocketServer;

/**
 * ServerRemote
 * @author AxGord <axgord@gmail.com>
 */
class ServerRemote {

	private var socket:SocketServer;
	private var protocol:RemoteProtocol;
	private var currentCommand:String;
	private var	listq:Array<Void->Void> = [];

	public function new(xml:Fast) {
		var port = Std.parseInt(xml.node.port.innerData);
		Sys.println('Remote Server running at $port');
		socket = new SocketServer(port);
		protocol = new RemoteProtocol(socket);
		protocol.onFile << fileHandler;
		protocol.onCommand << commandHandler;
		pony.time.DeltaTime.fixedUpdate << runListq;
	}

	private function runListq():Void {
		if (listq.length > 0) listq.shift()();
	}

	private function fileHandler(name:String, data:haxe.io.Bytes):Void {
		log('Get file: $name (' + data.length + ')');
		File.saveBytes(name, data);
		listq.push(protocol.fileReceivedRemote.bind(name));
	}

	private function log(s:String):Void {
		Sys.println(s);
		listq.push(protocol.logRemote.bind(s));
	}

	private function commandHandler(command:String):Void {
		currentCommand = command;
		log(command);
		var p = ChildProcess.exec(command, execHandler);
		p.stdout.on('data', log);
		p.stderr.on('data', log);
		p.on('exit', childExitHandler);
	}

	private function execHandler(err:Null<ChildProcessExecError>, a1:String, a2:String):Void {
		//log('haxe server is exec');
	}

	private function childExitHandler(code:Int):Void {
		log('Child exited with code $code');
		listq.push(protocol.commandCompleteRemote.bind(currentCommand));
	}

}
#end