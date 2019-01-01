package pony.net.http.modules.mkeyauth;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * MKeyAuthPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MKeyAuthPut extends TplPut<MKeyAuthConnect, {}> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String {
		if (name == 'keyauth') {
			if (a.authed())
				return @await sub(a, null, MKeyAuthPutSub, content);
			else
				return '';
		}
		else {
			return @await super.tag(name, content, arg, args, kid);
		}
	}
	
}