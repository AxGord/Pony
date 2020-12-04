package pony.net.http.modules.mmodels;

import pony.text.tpl.ITplPut;
import pony.text.tpl.TplData;
import pony.text.tpl.TplPut;

/**
 * ModelPut
 * @author AxGord <axgord@gmail.com>
 */
@:build(com.dongxiguo.continuation.Continuation.cpsByMeta(":async"))
class ModelPut extends TplPut<ModelConnect, Dynamic> {

	private var list:Map<String, ITplPut>;

	public function new(a:ModelConnect, b:Dynamic, parent:ITplPut) {
		super(a, b, parent);
		list = [for (k in a.actions.keys()) k => a.actions[k].tpl(this)];
	}

	@:async
	override public function tag(name:String, content:TplData, arg:String, args:Map<String, String>, ?kid:ITplPut):String
	{
		if (list.exists(name))
			return @await list.get(name).tag(name, content, arg, args, kid);
		else
			return @await super.tag(name, content, arg, args, kid);
	}

}