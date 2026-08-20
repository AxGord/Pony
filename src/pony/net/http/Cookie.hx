package pony.net.http;

/**
 * Cookie
 * @author AxGord
 */
class Cookie {

	private var oldCookie: Map<String, String> = [];
	private final newCookie: Map<String, String> = [];

	public function new(?cookie: String, ?mapCookie: Map<String, String>) {
		if (cookie != null) {
			final a: Array<String> = cookie.split(';');
			for (e in a) {
				final kv: Array<String> = e.split('=').map(StringTools.trim);
				// todo: fix double cookie problem
				oldCookie[kv[0]] = kv[1];
			}
		} else if (mapCookie != null)
			oldCookie = mapCookie;
	}

	public function toString(?domain: String): String {
		// domain = domain != null ? 'domain=$domain' : '';
		var s: String = '';
		for (k => value in newCookie) {
			s += '$k=${value};'; // + ';HttpOnly;$domain';
		}
		return s;
	}

	public function get(name: String): String {
		return newCookie.exists(name) ? newCookie[name] : oldCookie[name];
	}

	public inline function set(name: String, value: String): Void newCookie.set(name, value);

}
