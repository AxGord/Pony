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

import pony.Dictionary;
import pony.magic.Declarator;
import pony.Tools;

class ServersideStorage implements Declarator
{
	public var clients:Map<String, Map<String, Dynamic>> = new Map<String, Map<String, Dynamic>>();
	@:arg private var keyName:String = 'PonyKey';
	
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
		if (!clients.exists(key))
			clients.set(key, new Map<String, Dynamic>());
		return clients.get(key);
	}
	
}