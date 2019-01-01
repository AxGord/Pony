package pony.net.http.modules.mfb;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * MFBPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MFBPut extends TplPut<MFBConnect, {}> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String {
		if (name == 'facebook') {
			if (content == null) {
				return Std.string(a.token);
			} else {
				return @await sub(a, null, MFBPutSub, content);
			}
		} else {
			return @await super.tag(name, content, arg, args, kid);
		}
	}
	
}