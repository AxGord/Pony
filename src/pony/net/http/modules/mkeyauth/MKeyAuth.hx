package pony.net.http.modules.mkeyauth;

import pony.fs.Dir;
import pony.net.http.WebServer.EConnect;

/**
 * MKeyAuth
 * @author AxGord <axgord@gmail.com>
 */
@:final class MKeyAuth implements IModule {

	inline public static var PARAM:String = 'authkey';
	inline public static var SESSION:String = 'keyAuthed';
	
	private var keys:Array<String>;
	public var server:WebServer;
	
	public function new(keys:Array<String>) this.keys = keys;
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
	}
	
	public function connect(cpq:CPQ):EConnect {
		if (cpq.connection.params.exists(PARAM)) {
			var key:String = cpq.connection.params.get(PARAM);
			if (key == null) {
				cpq.connection.sessionStorage[SESSION] = false;
				cpq.connection.params.remove(PARAM);
				cpq.connection.endAction();
			} else if (keys.indexOf(key) != -1) {
				cpq.connection.sessionStorage[SESSION] = true;
				cpq.connection.params.remove(PARAM);
				cpq.connection.endAction();
			} else {
				cpq.connection.error('Access error');
			}
			return BREAK;
		} else {
			return REG(cast new MKeyAuthConnect(this, cpq));
		}
	}
	
}