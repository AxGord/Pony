/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.net.http.platform.nodejs;

import js.Node;
import pony.net.http.IHttpConnection;
import pony.net.http.ServersideStorage;

using Reflect;

class HttpServer
{
	private static var spdy(get, never):Dynamic;
	private var server:NodeHttpServer;
	private var spdyServer:Dynamic;
	public var storage:ServersideStorage;
	
	inline private static function get_spdy():Dynamic return Node.require('spdy');
	
	public function new(host:String=null, port:Int=80, ?spdyConf:Dynamic)
	{
		server = Node.http.createServer(listen);
		server.listen(port, host, createHandler);
		storage = new ServersideStorage();
		
		if (spdyConf != null) {
			var options = {
			  key: Node.fs.readFileSync(Node.__dirname + '/keys/spdy-key.pem'),
			  cert: Node.fs.readFileSync(Node.__dirname + '/keys/spdy-cert.pem'),
			  ca: Node.fs.readFileSync(Node.__dirname + '/keys/spdy-csr.pem')
			};
			
			spdyServer = spdy.createServer(options, listen).listen(spdyConf.hasField('port') ? spdyConf.port : 443, createSpdyHandler);
		}
	}
	
	private function listen(req:NodeHttpServerReq, res:NodeHttpServerResp):Void {
		trace(req.method+': ' + req.url);
		//trace(req.headers);
		res.setHeader('Server', 'PonyHttpServer');
		switch (req.method/*.toUpperCase()*/) {
			case 'POST':
				var s:String = '';
				untyped req.addListener('data', function(d:String):Void {
					s += d;
				});
				var me = this;
				untyped req.addListener('end', function(Void):Void {
					var h = new Map<String, String>();
					var o:Dynamic = Node.require('querystring').parse(s);
					for (f in o.fields())
						h.set(f, o.field(f));
						
					var a:Dynamic = untyped me.server.address();
					me.request(new HttpConnection('http://' + a.address + ':' + a.port + req.url, me.storage, req, res, h));
				});
			case 'GET':
				var a:Dynamic = untyped server.address();
				request(new HttpConnection('http://' + a.address + ':' + a.port + req.url, storage, req, res, new Map<String, String>()));
			case 'OPTIONS':
				res.setHeader('Allow', 'POST, GET');
				res.end();
			case 'DELETE', 'PUT':
				res.statusCode = 405;
				res.end();
			default:
				res.statusCode = 501;
				res.end();
		}
	}
	
	private function createHandler():Void {
		var a:Dynamic = untyped server.address();
		trace('HTTP Server running at http://' + a.address + ':' + a.port);
	}
	
	private function createSpdyHandler():Void {
		var a:Dynamic = untyped spdyServer.address();
		trace('SPDY Server running at http://' + a.address + ':' + a.port);
	}
	
	public dynamic function request(connection:IHttpConnection):Void {
		connection.sendText('Welcome from Pony Http Server');
	}
	
}