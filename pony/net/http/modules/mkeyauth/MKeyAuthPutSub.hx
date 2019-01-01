package pony.net.http.modules.mkeyauth;

import pony.net.http.modules.mlang.MLangConnect;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * MKeyAuthPutSub
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MKeyAuthPutSub extends TplPut<MKeyAuthConnect, ITplPut> {
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String {
		if (name == 'logout') {
			var url = '?'+MKeyAuth.PARAM;
			if (arg == 'a') {
				var lang:MLangConnect = cast a.cpq.modules['MLang'];
				var text = 'Logout';
				if (lang != null) text = lang.translate('en', text);
				return '<a href="$url">$text</a>';
			} else {
				return url;
			}
		} else {
			if (b != null) {
				return @await b.shortTag(name, arg, kid);
			} else {
				return @await super.shortTag(name, arg, kid);
			}
		}
	}
	
}