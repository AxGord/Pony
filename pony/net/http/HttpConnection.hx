/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

import sys.FileSystem;
import pony.fs.File;
import pony.magic.HasAbstract;
import pony.text.ParseBoy;

/**
 * HttpConnection
 * @author AxGord
 */

class HttpConnection implements HasAbstract
{

	inline static var indexFileShort:String = 'index.htm';
	inline static var indexFile:String = indexFileShort + 'l';

	public var method:String;
	public var post:Map<String, String>;
	public var fullUrl:String;
	public var url:String;
	public var params:Map<String, String>;
	public var sessionStorage:Map<String, Dynamic>;
	public var host:String;
	public var protocol:String;
	public var languages:Array<String>;
	public var cookie:Cookie;
	public var end:Bool;

	public function new(fullUrl:String)
	{
		//trace(fullUrl);
		end = false;
		languages = [];
		sessionStorage = new Map<String, Dynamic>();
		this.fullUrl = fullUrl;
		var pb:ParseBoy<Void> = new ParseBoy<Void>(fullUrl);
		pb.gt(['://']);
		protocol = pb.str();
		pb.gt(['/']);
		host = pb.str();
		params = null;
		if (pb.gt(['?']) == 0) {
			url = pb.str();
			params = parseData(pb);
		} else {
			url = pb.str();
			params = new Map<String, String>();
		}
	}
	
	private function rePost():Void {
		if (method == 'POST' && params.exists('re')) {
			sessionStorage.set('post', post);
			endAction();
		} else if (sessionStorage.exists('post')) {
			post = sessionStorage.get('post');
			sessionStorage.remove('post');
		}
	}
	
	public function endAction():Void goto('/$url');
	@:abstract public function endActionPrevPage():Void;
	@:abstract public function goto(url:String):Void;
	@:abstract public function error(?message:String):Void;
	@:abstract public function notfound(?message:String):Void;
	@:abstract public function sendFile(file:File):Void;
	
	private function parseData(pb:ParseBoy<Void>):Map<String, String> {
		var params = new Map<String, String>();
		var loop:Bool = true;
		while (loop) {
			switch (pb.gt(['=', '&'])) {
				case 0:
					var v:String = pb.str();
					if (pb.gt(['&']) == -1) loop = false;
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
		return params;
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
	
	public function mix():Map<String, String> {
		var h = new Map<String, String>();
		for (k in params.keys())
			h.set(k, params.get(k));
		for (k in post.keys())
			h.set(k, post.get(k));
		return h;
	}

	public function sendFileOrIndexHtml(f:String):Void {
		if (FileSystem.exists(f)) {
			if (FileSystem.isDirectory(f)) {
				if (FileSystem.exists(f+indexFileShort))
					sendFile(f+indexFileShort);
				else if (FileSystem.exists(f+indexFile))
					sendFile(f+indexFile);
				else
					notfound();
			} else {
				sendFile(f);
			}
		} else {
			notfound();
		}
	}
	
}