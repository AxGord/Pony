package pony.net.http;

import pony.magic.HasAbstract;
import pony.net.http.CPQ;
import pony.text.tpl.ITplPut;

/**
 * ModuleConnect
 * @author AxGord
 */
class ModuleConnect<T> implements HasAbstract {
	
	public var base:T;
	public var cpq:CPQ;
	
	public function new(base:T, cpq:CPQ) {
		this.base = base;
		this.cpq = cpq;
	}
	
	@:abstract public function tpl(parent:ITplPut):ITplPut;
	
}