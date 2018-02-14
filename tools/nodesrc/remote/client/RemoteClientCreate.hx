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

class RemoteClientCreate {

	public var runned(default, null):Bool = false;

	private var protocol:RemoteProtocol;

	public function new(args:Array<String>) {
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
			protocol = RemoteClientMain.createProtocol(host, port, key);
			protocol.log.onLog << remoteLogHandler;
			protocol.onReady < protocolReadyHandler;
			runned = true;
		}
	}

	private function protocolReadyHandler():Void {
		protocol.file.enable();
		protocol.file.stream.onStreamData << streamDataHandler;
		protocol.file.stream.onStreamEnd << protocol.socket.destroy;
		protocol.file.stream.onError << error;
		protocol.getInitFileRemote();
	}

	private function error():Void {
		Sys.println('Error');
		Sys.exit(3);
	}

	private function streamDataHandler():Void Sys.print('.');

	private function remoteLogHandler(s:String):Void {
		for (e in s.split('\n')) if (e != null) Sys.println('| $e');
	}

}