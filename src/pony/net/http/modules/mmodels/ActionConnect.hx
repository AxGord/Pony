package pony.net.http.modules.mmodels;

import pony.tests.Errors;
import pony.net.http.CPQ;
import pony.net.http.ModuleConnect;
import pony.net.http.modules.mmodels.Model.ActResult;
import pony.text.tpl.ITplPut;

/**
 * ActionConnect
 * @author AxGord <axgord@gmail.com>
 */
class ActionConnect extends ModuleConnect<Action> {
	
	private var method:Dynamic;
	private var methodCheck:Dynamic;
	public var model:ModelConnect;
	public var pathQuery:String = '';
	public var actionPathQuery:String = '';
	public var hasPathArg:Bool = false;
	public var activePathTarget:String;
	private var tplInited:Bool = false;
	
	public function new(base:Action, cpq:CPQ, model:ModelConnect) {
		super(base, cpq);
		this.model = model;
		method = Reflect.field(model, base.name);
		methodCheck = Reflect.field(model, base.name+'Validate');
		if (methodCheck == null)
			methodCheck = Reflect.field(model, 'validate');
	}
	
	private function initTpl():Void {
		if (tplInited) return;
		tplInited = true;
		var p = model.base.activePathes[base.name];
		if (p != null) {
			activePathTarget = p.field == null ? 'id' : p.field;
			var apath:String = p.path;
			if (apath != null) {
				var q = [cpq.page].concat(cpq.query);
				var takeNext = false;
				var i = 0;
				for (e in q) {
					if (e != '') actionPathQuery = null;
					if (apath == '' && i > 1) break;
					i++;
					if (e == apath) takeNext = true;
					else if (takeNext) {
						actionPathQuery = e;
						break;
					}
				}
			}
		}
		
		if (model.base.pathes[base.name] != null) for (path in model.base.pathes[base.name]) {
			hasPathArg = true;
			var q = [cpq.page].concat(cpq.query);
			var takeNext = false;
			var i = 0;
			for (e in q) {
				if (e != '') pathQuery = null;
				if (path == '' && i > 1) break;
				i++;
				if (e == path) takeNext = true;
				else if (takeNext) {
					pathQuery = e;
					return;
				}
			}
		}
	}
	
	public function checkActivePath(data:Dynamic):Bool {
		return Reflect.field(data, activePathTarget) == actionPathQuery;
	}
	
	override public function tpl(parent:ITplPut):ITplPut {
		return new ActionPut(base, cpq, parent);
	}
	
	public function runAction(h:Map<String, String>):Bool {
		if (checkAccess()) {
			return action(h);
		} else {
			return false;
		}
	}
	
	public function action(h:Map<String, String>):Bool {
		return false;
	}
	
	public function call(args:Array<Dynamic>, cb:Dynamic->Void):Void {
		Reflect.callMethod(model, method, args.concat([cb]));
	}
	
	public function _callCheck(args:Array<Dynamic>):Errors {	
		return Reflect.callMethod(model, methodCheck, args);
	}
	
	public function checkAccess():Bool {
		if (model.base.access.exists(base.name)) {
			return Reflect.callMethod(model, Reflect.field(model, model.base.access[base.name]), []);
		} else {
			return true;
		}
	}
		
	public function callCheck(args:Array<Dynamic>, cb:ActResult->Void):Void {
		if (methodCheck != null) {
			var r = _callCheck(args);
			if (r.empty()) {
				call(args, function(b:Bool) cb(b ? OK : DBERROR));
			} else {
				cb(ERROR(r.result));
			}
		} else
			call(args, function(b:Bool) cb(b ? OK : DBERROR));
	}

	
}