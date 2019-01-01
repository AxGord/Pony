package pony.net.http.modules.mlink;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * MLinkPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MLinkPut extends TplPut<MLinkConnect, {}> {
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String {
		if (name == 'link') {
			return '/'+(arg == null ? '' : arg);
		} else {
			return @await super.shortTag(name, arg, kid);
		}
	}
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String {
		
		if (name == 'link') {
			arg = arg == null ? '' : arg;
			if (args.exists('a')) {
				var c = @await parent.tplData(content);
				return '<a href="/$arg"' + (a.cpq.page == arg || a.cpq.page == arg + '/'?' class="active"':'') + '>' + c + '</a>';
			} else {
				return @await sub(this, arg, MLinkPutSub, content);
			}
		} else {
			return @await super.tag(name, content, arg, args, kid);
		}
	}
	
}