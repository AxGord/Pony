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
package pony.net.neko;

#if neko
import sys.net.Socket;
import sys.net.Host;
import haxe.io.Error;
import haxe.io.Eof;
import pony.time.DeltaTime;

/**
 * SocketServer
 * @author AxGord <axgord@gmail.com>
 */
class SocketServer extends pony.net.SocketServerBase {

	private var server:Socket = new Socket();
	
	public function new(port:Int) {
		super();
		server.bind(new Host('127.0.0.1'), port);
		server.listen(1000);
		server.setBlocking(false);
		DeltaTime.fixedUpdate << waitNewConnection;
	}
	
	private function waitNewConnection():Void {
		try {
			var client:Socket = server.accept();
			var cl = addClient();
			cl.nekoInit(client);
		} catch (s:String) {
			if (s != 'Blocking')
				error(s);
		} catch (e:Any) {
			error(e);
		}
	}
	
	override public function destroy():Void {
		DeltaTime.fixedUpdate >> waitNewConnection;
		super.destroy();
		server.close();
		server = null;
	}
}
#end