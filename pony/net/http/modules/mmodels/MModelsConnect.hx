package pony.net.http.modules.mmodels;

import pony.net.http.ModuleConnect;
import pony.text.tpl.ITplPut;

/**
 * MModelsConnect
 * @author AxGord <axgord@gmail.com>
 */
@:final class MModelsConnect extends ModuleConnect<MModels> {

	public var list:Map<String,ModelConnect>;
	
	public function new(base:MModels, cpq:CPQ, list:Map<String,ModelConnect>) {
		super(base, cpq);
		this.list = list;
	}
	
	override public function tpl(parent:ITplPut):ITplPut {
		return new MModelsPut(this,
			[for (k in list.keys()) k => list[k].tpl(parent)],
			parent);
	}
	
}