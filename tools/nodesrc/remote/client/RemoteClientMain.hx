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

import pony.NPM;

/**
 * Remote Client Main
 * @author AxGord <axgord@gmail.com>
 */
class RemoteClientMain {

	private static function main():Void {
		NPM.source_map_support.install();
		var args = Sys.args();
		if (!new RemoteClientCreate(args).runned) new RemoteClient(args);
	}

	public static function createProtocol(host:String, port:Int, key:String):RemoteProtocol {
		if (host == null || port == null) {
			Sys.println('Not setted port or host');
			Sys.exit(1);
		}
		var client = new pony.net.SocketClient(host, port);
		client.onDisconnect < disconnectHandler;		
		var protocol = new RemoteProtocol(client);
		if (key != null) protocol.authRemote(key);
		return protocol;
	}

	public static function disconnectHandler():Void {
		Sys.println('Disconnect');
		Sys.exit(2);
	}

}