package pony.text.tpl;

import pony.text.tpl.Tpl;
import pony.text.tpl.TplPut;

/**
 * ValuePut
 * @author AxGord
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class ValuePut extends TplPut < String, {} > {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		return @await parent.tag(name, content, arg, args, null);
	}
	
	@:async
	override public function shortTag(name:String, arg:String, ?kid:ITplPut):String
	{
		if (name == 'value')
			return a;
		else
			return @await parent.shortTag(name, arg, null);
	}
	
}