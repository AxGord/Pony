package pony.net.http.modules.mvk;

import js.Node;
import pony.fs.Dir;
import pony.net.http.IModule;
import pony.net.http.WebServer;
import pony.net.http.sn.FB;
import pony.net.http.CPQ;
import pony.net.http.WebServer.EConnect;
import pony.text.TextTools;
import pony.text.tpl.ITplPut;
import pony.text.tpl.Tpl;
import pony.text.tpl.TplPut;

/**
 * MVK
 * @author AxGord <axgord@gmail.com>
 */
@:final class MVK implements IModule {

	static private var sdk:Class<Dynamic> = Node.require('vksdk');

	public var server:WebServer;
	public var buttonData:String;
	public var appid:Int;

	public var vk:Dynamic;

	public function new(appid:Int, secret:String) {
		this.appid = appid;
		vk = Type.createInstance(sdk, [{
			appId     : appid,
			appSecret : secret,
			secure    : true
		}]);
		var s = TextTools.includeFileFromCurrentDir('mvk.tpl');
		new Tpl(MVKPrePut, appid, s).gen(null, null, function(r) buttonData = r);
	}

	public function init(dir:Dir, server:WebServer):Void {
		this.server = server;
	}

	public function connect(cpq:CPQ):EConnect {
		if (cpq.connection.params.exists('vkauth')) {
			cpq.connection.sessionStorage.set('vk_token', cpq.connection.params['vkauth']);
			cpq.connection.params.remove('vkauth');
			cpq.connection.endAction();
			return BREAK;
		} else {
			return REG(cast new MVKConnect(this, cpq));
		}
	}

}

@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MVKPrePut extends TplPut<Int,{}> {
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'appid':
				return Std.string(a);
			case _:
				return @await super.shortTag(name, arg, kid);
		}
	}
}