package pony.net.http;

import pony.net.http.WebServer.CPQ;

/**
 * ModuleConnect
 * @author AxGord
 */
class ModuleConnect<T>
{
	public var base:T;
	public var cpq:CPQ;
	
	public function new(base:T, cpq:CPQ) {
		this.base = base;
		this.cpq = cpq;
	}
	
}