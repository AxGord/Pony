package pony.net.http.modules.mlang;

import pony.fs.Dir;
import pony.LangTable;
import pony.net.http.IModule;
import pony.net.http.WebServer;

/**
 * MLang
 * @author AxGord <axgord@gmail.com>
 */
@:final class MLang implements IModule {

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
