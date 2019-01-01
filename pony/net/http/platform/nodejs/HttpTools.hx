package pony.net.http.platform.nodejs;

import js.Node;

/**
 * HttpTools
 * @author AxGord
 */
class HttpTools {

	public static function get(url:String, cb:String->Void):Void {
		Node.http.get(Node.url.parse(url), function(res) {
			if (res.statusCode == 200) {
				var r = '';
				res.on("data", function(chunk) r += chunk);
				res.on("end", function() cb(r));
			} else {
				cb(null);
			}
		}).on('error', function(e) cb(null));
	}
	
	public static function getJson(url:String, cb:Dynamic->Void):Void {
		get(url, function(s:String) cb(Node.json.parse(s)));
	}
	
}