package pony.net.http.modules.mlang;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.Valuator;

/**
 * MLangPutSub
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MLangPutSub extends Valuator<MLangPut, String> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'selected') return @await super.tag(name, content, arg, args, kid);
		else {
			var r = @await valu(name, arg);
			if (r != null)
				return @await super.tag(name, content, arg, args, kid);
			else
				return @await parentTag(name, content, arg, args, kid);
		}
	}
	
	@:async
	override public function valuBool(name:String):Bool {
		if (name == 'selected') {
			return a.a.cpq.lang == b;
		} else
			return null;
	}
	
	@:async
	override public function valu(name:String, arg:String):String {
		return switch (name) {
			case 'name': b;
			case 'title': a.a.base.langTable.langs.get(b).title;
			case 'author':
				var a:String = a.a.base.langTable.langs.get(b).author;
				a != null ? a : '';
			default: null;
		}
	}
	
}