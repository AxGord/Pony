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
package pony.net.http.modules.mlang;

import pony.fs.Dir;
import pony.LangTable;
import pony.net.http.IModule;
import pony.net.http.WebServer;

@:final class MLang implements IModule
{
	public var server:WebServer;
	public var langTable:LangTable;
	
	public function new() { }
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
		langTable = new LangTable(dir + 'language', server.defaults.lang);
	}
	
	public function connect(cpq:CPQ):EConnect {
		if (cpq.connection.params.exists('language')) {
			var tc:String = cpq.connection.params.get('language');
			if (langTable.langs.exists(tc)) {
				cpq.connection.sessionStorage.set('language', tc);
				cpq.connection.params.remove('language');
				cpq.connection.endAction();
			} else {
				cpq.connection.error('Not exists language: '+tc);
			}
			return BREAK;
		} else {
			if (cpq.connection.params.exists('tryLanguage'))
				cpq.lang = cpq.connection.params.get('tryLanguage');
			else {
				var st:Map<String, Dynamic> = cpq.connection.sessionStorage;
				if (st.exists('language'))
					cpq.lang = st.get('language');
				else {
					for (l in cpq.connection.languages)
						if (langTable.langs.exists(l)) {
							cpq.lang = l;
							break;
						}
				}
			}
			return REG(cast new MLangConnect(this, cpq));
		}
	}
	
}
