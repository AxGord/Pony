package pony.net.http.modules.mtpl;

import pony.fs.Dir;
import pony.net.http.IModule;
import pony.net.http.WebServer;

/**
 * MTpl
 * @author AxGord
 */
@:final class MTpl implements IModule {
	
	public var server:WebServer;
	
	public function new() { }
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
	}
	
	public function connect(cpq:CPQ):EConnect {
		if (cpq.connection.params.exists('template')) {
			var tc:String = cpq.connection.params.get('template');
			if (server.tpl.exists(tc)) {
				cpq.connection.sessionStorage.set('template', tc);
				cpq.connection.params.remove('template');
				cpq.connection.endAction();
			} else {
				cpq.connection.error('Not exists template: '+tc);
			}
			return BREAK;
		} else {
			if (cpq.connection.params.exists('tryTemplate')) {
				cpq.template = server.tpl.get(cpq.connection.params.get('tryTemplate'));
			} else {
				var st:Map<String, Dynamic> = cpq.connection.sessionStorage;
				if (st.exists('template'))
					cpq.template = server.tpl.get(st.get('template'));
			}
			return REG(cast new MTplConnect(this, cpq));
		}
		
	}
	
}