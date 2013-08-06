package;

import pony.events.Signal;

enum Test {
	O; D;
}
/**
 * ...
 * @author AxGord
 */
class Main{

	public static function main() {
		var s = new Signal();
		s.add(function() trace(123));
		s.dispatch();
		
		Test.createByName
	}
	
}