package pony.net.http.platform.js;

import js.Browser;
import js.html.Node;
import pony.Queue;

/**
 * HttpTools
 * @author AxGord
 */
class HttpTools {
	
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