package pony.net.http.modules.mvk;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * MVKPutSub
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MVKPutSub extends TplPut<MVKConnect, {}> {

	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'ready') {
			var token = a.token;
			if (args.exists('!')) {
				if (token == null) {
					return @await sub(a, null, MVKPutSub, content);
				} else {
					return '';
				}
			} else {
				if (token == null) {
					return '';
				} else {
					return @await sub(a, null, MVKPutSub, content);	
				}
			}
			
		} else {
			return @await super.tag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		return switch (name) {
			case 'token': Std.string(a.token);
			case 'button': a.token != null ? '' : a.base.buttonData;
			case 'appid': Std.string(a.base.appid);
			case 'id': Std.string(@await a.getId());
			default: @await super.shortTag(name, arg, kid);
		}
	}
	
}