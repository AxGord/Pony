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
import sys.FileSystem;

/**
 * ServerMain
 * @author AxGord <axgord@gmail.com>
 */
class ServerMain {

	static var path:String;
	static var haxePort:String;

	static function main() {
		NPM.source_map_support.install();
		var xml = Utils.getXml();
		if (xml.hasNode.server) {
			var sx = xml.node.server;

			if (sx.hasNode.port && sx.hasNode.path) {
				path = sx.node.path.innerData;
				var port:Int = Std.parseInt(sx.node.port.innerData);
				var server:HttpServer = new HttpServer(port);
				server.request = connectHandler;
			}

			if (sx.hasNode.proxy) {
				var px = sx.node.proxy;
				var target = px.node.target.innerData;
				var port = px.node.port.innerData;
				NPM.http_proxy.createProxyServer({
					target: target,
					headers: {'Host': '127.0.0.1:$port'}
				}).on('error', function (err, req, res) {
					res.writeHead(500, {
						'Content-Type': 'text/plain'
					});
					res.end('Something went wrong.');
				}).listen(Std.parseInt(port));
			}

			if (sx.hasNode.haxe) {
				haxePort = sx.node.haxe.innerData;
				runHaxeServer();
			}

			if (sx.hasNode.remote) {
				new ServerRemote(sx.node.remote);
			}

		}
	}

	static function runHaxeServer():Void {
		var r = 'haxe -v --wait $haxePort';
		Sys.println(r);
		var p = ChildProcess.exec(r, execHandler);
		p.stdout.on('data', traceData);
		p.stderr.on('data', traceData);
		p.on('exit', childExitHandler);
	}

	static function execHandler(err:Null<ChildProcessExecError>, a1:String, a2:String):Void {
		Sys.println('haxe server is exec');
		runHaxeServer();
	}

	static function childExitHandler(code:Int):Void {
		Sys.println('Child exited with code $code');
	}

	static function traceData(data):Void {
		Sys.print(data);
	}

	static function connectHandler(connection:IHttpConnection):Void {
		Sys.println('Http get: ' + connection.url);
		connection.sendFileOrIndexHtml(path + connection.url);
	}

}
#end