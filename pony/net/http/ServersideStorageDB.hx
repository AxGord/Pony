package pony.net.http;

import haxe.ds.IntMap;
import haxe.Serializer;
import haxe.Unserializer;
import pony.db.DBV;
import pony.db.mysql.Flags;
import pony.db.mysql.Types;
import pony.db.Table;
import pony.Dictionary;
import pony.magic.Declarator;
import pony.Tools;

/**
 * ServersideStorageDB
 * @author AxGord
 */
class ServersideStorageDB implements Declarator {

	private var orig:Map<String, Dynamic>;
	private var client:Map<String, Dynamic>;
	private var key:String;
	@:arg private var keyName:String = 'PonyKey';
	@:arg private var table:Table;
	
	public function new():Void {
		table.prepare( [
			{name: 'client', length: 36, type: Types.VARCHAR, flags:[Flags.NOT_NULL]},
			{name: 'key', length: 36, type: Types.VARCHAR, flags:[Flags.NOT_NULL]},
			{name: 'value', length: 256, type: Types.VARCHAR, flags:[Flags.NOT_NULL]}
		], function(r) if (!r) throw 'Can\'t prepare table for storage');
	}
	
	public function getClient(cookie:Cookie):Map<String, Dynamic> {
		var key:String = cookie.get(keyName);
		if (key == null) {
			var k:String = Tools.randomString();
			cookie.set(keyName, k);
			return getClientByKey(k);
		} else {
			return getClientByKey(key);
		}
		return null;
	}
	
	public function getClientByKey(key:String):Map<String, Dynamic> {
		this.key = key;
		client = new Map<String, Dynamic>();
		orig = new Map<String, Dynamic>();
		table.select('key', 'value').where(client == $key).get(function(d) {
			client = [for (e in d) e.key => Unserializer.run(e.value)];
			orig = [for (e in d) e.key => e.value];
		} );//Works only for sync
		return client;
	}
	
	public function save():Void {
		for (k in client.keys()) if (!orig.exists(k)) {
			table.insert([
				'client' => (key:DBV),
				'key' => (k:DBV),
				'value' => (Serializer.run(client[k]):DBV)
			], function(r) if (!r) throw 'Can\'t save storage');
		} else {
			var s = Serializer.run(client[k]);
			if (s != orig[k])
				table.where(client == $key && key == $k).update([
					'value' => (s:DBV)
				], function(r) if (!r) throw 'Can\'t save storage');
		}
	}
	
}