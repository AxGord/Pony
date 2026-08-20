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
		for (k in newCookie.keys()) {
			s += '$k=${newCookie[k]};'; // + ';HttpOnly;$domain';
		}
		return s;
	}

	public function get(name: String): String {
		if (newCookie.exists(name))
			return newCookie[name];
		else
			return oldCookie[name];
	}

	inline public function set(name: String, value: String): Void newCookie.set(name, value);

}
