package pony.net.http.modules.mmodels;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * MModelsPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
@:final class MModelsPut extends TplPut<MModelsConnect, Map<String, ITplPut>> {
	
	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (b.exists(name))
			return @await b.get(name).tplData(content);
		else
			return @await super.tag(name, content, arg, args, kid);
	}
	
}