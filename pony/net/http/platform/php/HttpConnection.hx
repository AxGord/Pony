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
package pony.net.http.platform.php;

import pony.fs.File;
import pony.text.ParseBoy;

/**
 * HttpConnection
 * @author AxGord
 */
class HttpConnection extends pony.net.http.HttpConnection implements IHttpConnection {

	public function new(storage:ServersideStorageDB) 
	{
		post = new Map();
		super('http://' + php.Web.getHostName() + php.Web.getURI() + '?' + php.Web.getParamsString());
		
		method = php.Web.getMethod();
		post = parseData(new ParseBoy<Void>(php.Web.getPostData()));
		
		cookie = new Cookie(php.Web.getCookies());
		sessionStorage = storage.getClient(cookie);
		rePost();
	}
	
	override public function sendFile(file:File):Void {
		php.Web.setHeader('Content-Description', 'File Transfer');
		php.Web.setHeader('Content-Type', Mime.get[file.ext]);
		//php.Web.setHeader('Content-Disposition', 'attachment; filename=' + file.name);
		php.Web.setHeader('Content-Transfer-Encoding', 'binary');
		php.Web.setHeader('Expires', '0');
		php.Web.setHeader('Cache-Control', 'must-revalidate, post-check=0, pre-check=0');
		php.Web.setHeader('Pragma', 'public');
		php.Web.setHeader('Content-Length', Std.string(file.size));
		untyped __call__('readfile', file.firstExists);
		untyped __call__('exit');
		
	}
	
	override public function endAction():Void {
		writeCookie();
		php.Web.setHeader('Location', '/'+url);
		php.Web.setHeader('Cache-Control', 'private');
		php.Web.setReturnCode(302);
		php.Lib.print('<html><body><a href=".">Click here</a></body></html>');
		end = true;
		
	}
	override public function error(?message:String):Void {
		php.Lib.print(message!=null?message:'Error');
		end = true;
	}
	override public function notfound(?message:String):Void {
		php.Lib.print(message!=null?message:'Not found');
		end = true;
	}
	public function sendHtml(text:String):Void {
		writeCookie();
		php.Web.setHeader('Content-Type', 'text/html; charset=utf-8');
		php.Lib.print(text);
		end = true;
	}
	public function sendText(text:String):Void {
		writeCookie();
		php.Lib.print(text);
		end = true;
	}
	
	private function writeCookie():Void {
		var s:String = cookie.toString();
		if (s != '') {
			php.Web.setHeader('Set-Cookie', s);
			php.Web.setHeader('Cookie Domain', host);
		}
		end = true;
	}
}