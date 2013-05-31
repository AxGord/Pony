package;

import pony.events.Signal;
/**
 * ...
 * @author AxGord
 */
class Main{

	public static function main() {
		var s = new Signal();
		s.add(function() trace(123));
		s.dispatch();
	}
	
}