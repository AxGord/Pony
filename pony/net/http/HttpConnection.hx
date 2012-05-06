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
package pony.net.http;

import pony.fs.File;
import pony.ParseBoy;

/**
 * ...
 * @author AxGord
 */

class HttpConnection
{
	public var method:String;
	public var post:Hash<String>;
	public var fullUrl:String;
	public var url:String;
	public var params:Hash<String>;
	public var sessionStorage:Hash<Dynamic>;
	public var host:String;
	public var protocol:String;
	public var languages:Array<String>;
	public var cookie:Cookie;
	public var end:Bool;

	public function new(fullUrl:String)
	{
		end = false;
		languages = [];
		sessionStorage = new Hash<Dynamic>();
		this.fullUrl = fullUrl;
		var pb:ParseBoy<Void> = new ParseBoy<Void>(fullUrl);
		pb.goto(['://']);
		protocol = pb.str();
		pb.goto(['/']);
		host = pb.str();
		params = new Hash<String>();
		if (pb.goto(['?']) == 0) {
			url = pb.str();
			var loop:Bool = true;
			while (loop) {
				switch (pb.goto(['=', '&'])) {
					case 0:
						var v:String = pb.str();
						if (pb.goto(['&']) == -1) loop = false;
						params.set(v, pb.str());
					case 1:
						var p:String = pb.str();
						if (p != '')
							params.set(p, null);
					default:
						var p:String = pb.str();
						if (p != '')
							params.set(p, null);
						loop = false;
				}
			}
		} else
			url = pb.str();
	}
	/*
	public function sendFile(file:File):Void {
		
	}
	
	public function endAction():Void {
		
	}
	
	public function error(?message:String):Void {
		
	}
	
	public function sendHtml(text:String):Void {
		
	}
	*/
	
	public function mix():Hash<String> {
		var h = new Hash<String>();
		for (k in params.keys())
			h.set(k, params.get(k));
		for (k in post.keys())
			h.set(k, post.get(k));
		return h;
	}
	
}