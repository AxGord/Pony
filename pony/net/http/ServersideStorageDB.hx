/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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

class ServersideStorageDB implements Declarator
{
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