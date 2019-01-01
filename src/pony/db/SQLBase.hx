package pony.db;

import pony.events.WaitReady;
import pony.Logable;

/**
 * SQLBase
 * @author AxGord <axgord@gmail.com>
 */
class SQLBase extends Logable {
	
	/**
	 * Connected
	 */
	public var connected:WaitReady;
	
	/**
	 * Forced get fields info after query
	 */
	public var hack:String;
	
	private function new() {
		super();
		connected = new WaitReady();
	}
	
}