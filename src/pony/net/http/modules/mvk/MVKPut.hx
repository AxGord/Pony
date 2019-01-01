package pony.net.http.modules.mvk;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * MVKPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MVKPut extends TplPut<MVKConnect, {}> {

	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'vkontakte') {
			if (content == null) {
				return Std.string(a.token);
			} else {
				return @await sub(a, null, MVKPutSub, content);
			}
		} else {
			return @await super.tag(name, content, arg, args, kid);
		}
	}
	
}