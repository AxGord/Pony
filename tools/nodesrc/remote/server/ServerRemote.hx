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
package remote.server;
#if nodejs
import pony.net.SocketServer;
import pony.net.SocketClient;
import pony.Pair;
import haxe.xml.Fast;

using pony.text.XmlTools;

/**
 * ServerRemote
 * @author AxGord <axgord@gmail.com>
 */
class ServerRemote {

	private var socket:SocketServer;
	private var key:String = null;
	private var commands:Map<String, Array<Pair<Bool, String>>> = new Map();
	private var instanse:ServerRemoteInstanse;
	private var cmdLock:Bool = false;
	private var allowForGet:Array<String>;

	public function new(xml:Fast) {
		var port = Std.parseInt(xml.node.port.innerData);
		try {
			key = StringTools.trim(xml.node.key.innerData);
		} catch (_:Any) {}

		allowForGet = [for (node in xml.nodes.allow) StringTools.trim(node.innerData)];

		for (node in xml.node.commands.elements) {
			var d:Pair<Bool, String> = new Pair(!node.isFalse('zipLog'), StringTools.trim(node.innerData));
			if (!commands.exists(node.name))
				commands[node.name] = [d];
			else
				commands[node.name].push(d);
		}

		Sys.println('Remote Server running at $port');
		socket = new SocketServer(port);
		socket.onConnect << connectHandler;
	}

	private function connectHandler(client:SocketClient):Void {
		Sys.println('New connection');
		if (instanse == null && !cmdLock) {
			Sys.println('Accept');
			instanse = new ServerRemoteInstanse(client, key, commands, allowForGet);
			instanse.onBeginCommand = beginCommandHandler;
			instanse.onEndCommand = endCommandHandler;
			client.onClose < closeHandler;
		} else {
			Sys.println('Deny');
			client.destroy();
		}
	}

	private function closeHandler():Void instanse = null;

	private function beginCommandHandler():Void cmdLock = true;
	private function endCommandHandler():Void cmdLock = false;

}
#end