package pony.net.http.modules.mtpl;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;
import pony.text.tpl.TplSystem;

/**
 * MTplPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MTplPut extends TplPut<MTpl, CPQ> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (name == 'templates') {
			return @await many(a.server.tpl, MTplPutSub, content, arg);
		} else if (name == 'template')
			return @await sub(this, b.template, MTplPutSub, content);
		else
			return @await super.tag(name, content, arg, args, kid);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		switch (name) {
			case 'static' if (arg != null):
				#if php
				return '/'+b.template._static[arg].firstExists;//todo: site directory
				#else
				return '/tpl/${b.template.name}/$arg';
				#end
			case 'template':
				return b.template.name;
			case 'templates':
				return @await TplPut.manyEasy(a.server.tpl, getName, arg == null ? ', ' : arg);
			default:
				return @await super.shortTag(name, arg, kid);
		}
	}
	
	private static function getName(v:TplSystem, cb:String->Void):Void cb(v.name);
	
}