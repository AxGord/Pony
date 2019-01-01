package pony.net.http.modules.mlang;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;
import pony.text.tpl.TplSystem.Manifest;

/**
 * MLangPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MLangPut extends TplPut<MLangConnect, {}> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'l') {
			if (args.exists('not'))
				return a.cpq.lang == args.get('not') ? '' : @await tplData(content);
			else {
				var d:String = kid != null ? @await kid.tplData(content) : @await tplData(content);
				return l(d, args);
			}
		} else if (name == 'languages') {
			return @await many(null, a.base.langTable.langs.keys(), MLangPutSub, content, arg);
		} else if (name == 'language')
			return @await sub(this, a.cpq.lang, MLangPutSub, content);
		else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'language':
				return a.cpq.lang;
			case 'languages':
				return @await TplPut.manyEasy(null, a.base.langTable.langs.keys(), null, arg == null ? ', ' : arg);
			default:
				return @await super.shortTag(name, arg, kid);
		}
	}
	
	private function l(d:String, args:Map<String, String>):String {
		var m:Manifest = a.cpq.template.manifest;
		var from:String = args.exists('from') ? args.get('from') : (m != null && m.language != null ? m.language : a.base.server.defaults.lang);
		var to:String = args.exists('to') ? args.get('to') : a.cpq.lang;
		return a.base.langTable.translate(from, to, d);
	}
	
}