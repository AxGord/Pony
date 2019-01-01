package pony.net.http.modules.mfb;

import pony.fs.Dir;
import pony.net.http.IModule;
import pony.net.http.sn.FB;
import pony.net.http.CPQ;
import pony.net.http.WebServer.EConnect;
import pony.text.TextTools;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplPut;

/**
 * MFB
 * @author AxGord
 */
@:final class MFB implements IModule {

	public var fb:FB;
	
	public var appid:String;
	public var server:WebServer;
	public var buttonData:String;
	
	public function new(appid:String, secret:String = '', phpsdk:String = "facebook-php-sdk-v4/autoload.php") {
		#if php
			fb = new FB(appid, secret, phpsdk);
		#else
			fb = new FB(appid, secret);
		#end
		this.appid = appid;
		var s = TextTools.includeFileFromCurrentDir('mfb.tpl');
		new Tpl(MFBPrePut, appid, s).gen(null, null, function(r) buttonData = r);
	}
	
	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
	}
	
	public function connect(cpq:CPQ):EConnect {
		if (cpq.connection.params.exists('fbauth')) {
			cpq.connection.sessionStorage.set('fb_token', cpq.connection.params['fbauth']);
			cpq.connection.params.remove('fbauth');
			cpq.connection.endAction();
			return BREAK;
		} else {
			return REG(cast new MFBConnect(this, cpq));
		}
	}
	
}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MFBPrePut extends TplPut<String, {}> {
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'appid':
				return a;
			case _:
				return @await super.shortTag(name, arg, kid);
		}
	}
}