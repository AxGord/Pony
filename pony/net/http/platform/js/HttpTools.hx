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
package pony.net.http.platform.js;
import js.Browser;
import js.html.Node;
import pony.Queue;

/**
 * HttpTools
 * @author AxGord
 */
class HttpTools 
{
	
	private static var snode:Node;
	private static var getJsonQueue:Queue < String->(Dynamic->Void)->Void > = new Queue(_getJson);
	
	inline private static function regcb(cb:Dynamic->Void) untyped Browser.window.ponyCallbackFunc = cb;
	
	public static function getJson(url:String, cb:Dynamic->Void):Void getJsonQueue.call(url, cb);
	
	private static function _getJson(url:String, cb:Dynamic->Void):Void {
		regcb(function(r:Dynamic) {
			Browser.document.getElementsByTagName("head")[0].removeChild(snode);
			snode = null;
			regcb(null);
			cb(r);
			getJsonQueue.next();
		});
		var script = Browser.document.createElement('SCRIPT');
		url += '&callback=ponyCallbackFunc';
		untyped script.src = url;
		snode = Browser.document.getElementsByTagName("head")[0].appendChild(script);
	}
	
}