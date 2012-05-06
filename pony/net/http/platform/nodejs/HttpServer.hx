/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pony.net.http.Cookie;
import pony.net.http.IHttpConnection;
import pony.fs.File;
import pony.net.http.ServersideStorage;
import pony.ParseBoy;

using Reflect;

class HttpServer
{
	private static var spdy:Dynamic = Node.require('spdy');
	private var server:NodeHttpServer;
	private var spdyServer:Dynamic;
	public var storage:ServersideStorage;
	
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
		res.setHeader('Server', 'PonyNode');
		switch (req.method/*.toUpperCase()*/) {
			case 'POST':
				var s:String = '';
				untyped req.addListener('data', function(d:String):Void {
					s += d;
				});
				var me = this;
				untyped req.addListener('end', function(Void):Void {
					var h = new Hash<String>();
					var o:Dynamic = Node.queryString.parse(s);
					for (f in o.fields())
						h.set(f, o.field(f));
						
					var a:Dynamic = untyped me.server.address();
					me.request(new HttpConnection('http://' + a.address + ':' + a.port + req.url, me.storage, req, res, h));
				});
			case 'GET':
				var a:Dynamic = untyped server.address();
				request(new HttpConnection('http://' + a.address + ':' + a.port + req.url, storage, req, res, new Hash<String>()));
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
		connection.sendText('Hell world');
	}
	
}

class HttpConnection extends pony.net.http.HttpConnection, implements IHttpConnection {
	
	
	private static var fileSender:NodeHttpServerResp->String->Void = Node.require('fileSender').f;
	
	private var res:NodeHttpServerResp;
	
	public function new(url:String, storage:ServersideStorage, req:NodeHttpServerReq, res:NodeHttpServerResp, post:Hash<String>) {
		super(url);
		method = req.method;
		this.post = post;
		this.res = res;
		if (req.headers.hasField('accept-language')) {
			var pb:ParseBoy<Void> = new ParseBoy<Void>(req.headers.field('accept-language'));
			var n:Int;
			do {
				n = pb.goto([',', ';']);
				var s:String = pb.str();
				if (s.substr(0, 2) == 'q=') continue;
				var a:Array<String> = s.toLowerCase().split('-');
				if (a.length == 1) {
					langPush(a[0] + '-' + a[0]);
					langPush(a[0]);
				} else {
					langPush(a[0] + '-' + a[1]);
					langPush(a[1]);
					langPush(a[0]);
				}
			} while (n != -1);
		}
		cookie = new Cookie(req.headers.cookie);
		sessionStorage = storage.getClient(cookie);
		
		//re
		if (method == 'POST' && params.exists('re')) {
			sessionStorage.set('post', post);
			endAction();
		} else if (sessionStorage.exists('post')) {
			this.post = sessionStorage.get('post');
			sessionStorage.remove('post');
		}
	}
	
	private function langPush(s:String):Void {
		if (s != '' && Lambda.indexOf(languages, s) == -1)
			languages.push(s);
	}
	
	public inline function sendFile(file:File):Void {
		writeCookie();
		fileSender(res, file.getFirstExists());
	}
	
	public function endAction():Void {
		writeCookie();
		res.setHeader('Location', '/'+url);
		res.setHeader('Cache-Control', 'private');
		res.statusCode = 302;
		var t:String = '<html><body><a href=".">Click here</a></body></html>';
		res.setHeader('Content-Length', Buffer.byteLength(t, 'utf8'));
		res.end(t);
		end = true;
	}
	
	public function error(?message:String):Void {
		writeCookie();
		res.setHeader('Content-Type', 'text/html; charset=UTF-8');
		res.end(message == null ? 'Error' : 'Error: '+message);
		end = true;
	}
	
	public function sendHtml(text:String):Void {
		writeCookie();
		res.setHeader('Content-Type', 'text/html; charset=UTF-8');
		res.setHeader('Content-Length', Buffer.byteLength(text, 'utf8'));
		res.end(text);
		end = true;
	}
	
	public function sendText(text:String):Void {
		writeCookie();
		res.setHeader('Content-Type', 'text/plain; charset=UTF-8');
		res.setHeader('Content-Length', Buffer.byteLength(text, 'utf8'));
		res.end(text);
		end = true;
	}
	
	private function writeCookie():Void {
		var s:String = cookie.toString();
		if (s != '')
			res.setHeader('Set-Cookie', s);
		end = true;
	}
	
}