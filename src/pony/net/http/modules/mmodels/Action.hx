package pony.net.http.modules.mmodels;

import pony.net.http.CPQ;
import pony.net.http.WebServer.EConnect;

/**
 * Action
 * @author AxGord <axgord@gmail.com>
 */
class Action {
	public var id:Int;
	public var model:Model;
	public var name:String;
	public var args:Map<String, String>;
	
	public function new(model:Model, name:String, args:Array<{name: String, type: String}>) {
		this.model = model;
		this.name = name;
		this.args = new Map<String, String>();
		for (a in args)
			this.args.set(a.name, a.type);
		id = model.mm.lastActionId++;	
	}
		
	public function connect(cpq:CPQ, modelConnect:ModelConnect):Pair<EConnect, ISubActionConnect> {
		return new Pair(REG(cast new ActionConnect(this, cpq, modelConnect)), null);
	}
	
}