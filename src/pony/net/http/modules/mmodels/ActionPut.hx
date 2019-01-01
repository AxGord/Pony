package pony.net.http.modules.mmodels;

import pony.net.http.CPQ;
import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;

/**
 * ActionPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class ActionPut extends pony.text.tpl.TplPut<Action, CPQ> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		return "I can't be showing";
	}
	
}