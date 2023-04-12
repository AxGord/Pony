package pony.net.http.modules.mmodels;

import pony.db.Table;
import pony.net.http.CPQ;
import pony.text.tpl.ITplPut;

/**
 * ModelConnect
 * @author AxGord <axgord@gmail.com>
 */
#if !macro
@:autoBuild(pony.net.http.modules.mmodels.Builder.build())
#end
class ModelConnect extends ModuleConnect<Model> {

	private var db: Table;

	public var actions: Map<String, ActionConnect>;
	public var subactions: Map<String, ISubActionConnect>;

	private function new(base: Model, cpq: CPQ) {
		super(base, cpq);
		db = base.db.error(cpq.error);
	}

	public function action(h: Map<String, Map<String, String>>): Bool {
		for (k in h.keys()) if (actions[k].runAction(h.get(k))) return true;
		return false;
	}

	#if (haxe_ver < 4.2) override #end
	public function tpl(parent: ITplPut): ITplPut return new ModelPut(this, null, parent);

}