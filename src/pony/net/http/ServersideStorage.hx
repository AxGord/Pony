package pony.net.http;

import pony.magic.Declarator;
import pony.Random;

/**
 * ServersideStorage
 * @author AxGord
 */
class ServersideStorage implements Declarator {

	public var clients: Map<String, Map<String, Dynamic>> = new Map<String, Map<String, Dynamic>>();
	@:arg private var keyName: String = 'PonyKey';

	public function getClient(cookie: Cookie): Map<String, Dynamic> {
		var key: String = cookie.get(keyName);
		if (key == null) {
			var k: String = Random.randomString();
			cookie.set(keyName, k);
			return getClientByKey(k);
		} else {
			return getClientByKey(key);
		}
		return null;
	}

	public function getClientByKey(key: String): Map<String, Dynamic> {
		if (!clients.exists(key))
			clients.set(key, new Map<String, Dynamic>());
		return clients.get(key);
	}

}