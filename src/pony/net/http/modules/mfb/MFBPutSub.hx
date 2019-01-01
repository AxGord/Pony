package pony.net.http.modules.mfb;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * MFBPutSub
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MFBPutSub extends TplPut<MFBConnect, {}> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String {
		if (name == 'ready') {
			var token = a.token;
			if (args.exists('!')) {
				if (token == null) {
					return @await sub(a, null, MFBPutSub, content);
				} else {
					return '';
				}
			} else {
				if (token == null) {
					return '';
				} else {
					return @await sub(a, null, MFBPutSub, content);	
				}
			}
			
		} else {
			return @await super.tag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String {
		return switch (name) {
			case 'token': Std.string(a.token);
			case 'button': a.token != null ? '' : a.base.buttonData;
			case 'appid': a.base.appid;
			case 'id': @await a.getId();
			default: @await super.shortTag(name, arg, kid);
		}
	}
	
}