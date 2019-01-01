package pony.net.http;

/**
 * Cookie
 * @author AxGord
 */
class Cookie {
	
	private var oldCookie:Map<String, String>;
	private var newCookie:Map<String, String>;
	
	public function new(?cookie:String, ?mapCookie:Map<String,String>)
	{
		newCookie = new Map<String, String>();
		oldCookie = new Map<String, String>();
		if (cookie != null) {
			var a:Array<String> = cookie.split(';');
			for (e in a) {
				var kv:Array<String> = e.split('=').map(StringTools.trim);
				//todo: fix double cookie problem
				oldCookie.set(kv[0], kv[1]);
			}
		} else if (mapCookie != null) oldCookie = mapCookie;
	}
	
	public function toString(?domain:String):String {
		//domain = domain != null ? 'domain=$domain' : '';
		var s:String = '';
		for (k in newCookie.keys()) {
			s += k + '=' + newCookie.get(k) + ';';// + ';HttpOnly;$domain';
		}
		return s;
	}
	
	public function get(name:String):String {
		if (newCookie.exists(name))
			return newCookie.get(name);
		else
			return oldCookie.get(name);
	}
	
	inline public function set(name:String, value:String):Void newCookie.set(name, value);
	
}