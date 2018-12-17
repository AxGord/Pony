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

import haxe.io.Output;
import haxe.io.Bytes;
import js.Node;
import hxbit.Serializer;
import haxe.Log;
import pony.Logable;
import pony.Tools;
import module.NModule;
import types.ImageminConfig;
import types.PoeditorConfig;
import types.DownloadConfig;
import types.BmfontConfig;
import pony.net.rpc.RPC;
import pony.net.SocketServer;
import pony.net.SocketClient;
import pony.NPM;

class NMain extends Logable {

	private var client:SocketClient;
	private var rpc:NProtocol;

	private function new() {
		super();
		var port:Null<Int> = Std.parseInt(Sys.args()[0]);
		if (port == null) throw 'Port not set';
		NPM.capture_console.startCapture(Node.process.stdout, log);
		NPM.capture_console.startCapture(Node.process.stderr, log);
		
		client = new SocketClient(Utils.NPORT);
		Node.process.on('uncaughtException', errorHandler);
		client.onLog << eLog;
		client.onError << eError;
		rpc = new NProtocol(client);
		onLog << rpc.log.logRemote;
		onError << rpc.log.errorRemote;
		rpc.onBmfont << bmfontHandler;
		rpc.onImagemin << imageminHandler;
		rpc.onPoeditor << poeditorHandler;
		rpc.onDownload << downloadHandler;
	}

	private function errorHandler(err:js.Error):Void error(err.stack);

	private function bmfontHandler(cfg:Array<BmfontConfig>):Void {
		listen(cast new module.Bmfont(cfg));
	}

	private function imageminHandler(cfg:Array<ImageminConfig>):Void {
		listen(cast new module.Imagemin(cfg));
	}

	private function poeditorHandler(cfg:Array<PoeditorConfig>):Void {
		listen(cast new module.Poeditor(cfg));
	}

	private function downloadHandler(cfg:Array<DownloadConfig>):Void {
		listen(cast new module.Download(cfg));
	}

	private function listen(m:NModule<Any>):Void {
		m.onLog << log;
		m.onError << error;
		m.onFinish < rpc.finishRemote;
		m.start();
	}

	private static function main():Void new NMain();

}