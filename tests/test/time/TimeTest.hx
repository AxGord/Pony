package time ;

import massive.munit.Assert.*;
import pony.time.Time;
import pony.time.TimeInterval;

class TimeTest 
{
	@Test
	public function simple():Void
	{
		var time:Time = '1:00';
		areEqual((time:Int), 60000);
	}
	
	@Test
	public function add():Void {
		var t1:Time = '1:40';
		var t2:Time = '30';
		areEqual(t1 + t2, ('2:10':Time));
	}
	
	@Test
	public function extr():Void {
		var d:Time = '-90';
		areEqual(d, ('-01:30':Time));
	}
	
	@Test
	public function named():Void {
		var t:Time = '2m 30s';
		areEqual(t, ('2:30':Time));
	}
	
	@Test
	public function neg():Void {
		var n:Time = -1000;
		areEqual((n:String), '-00:00:01');
	}
	
	@Test
	public function timeInterval():Void {
		var t:TimeInterval = 500...3000;
		areEqual(t.toString(), '00:00:00.500 ... 00:00:03');
		var t:TimeInterval = '27min ... 30min';
		areEqual(t.toString(), '00:27:00 ... 00:30:00');
	}
	
	@Test
	public function timeInInterval():Void {
		var t:TimeInterval = '27min ... 30min';
		isTrue(t.check('27:30'));
		isFalse(t.check('01:30'));
		var t:TimeInterval = '3min';
		isTrue(t.check('01:30'));
		isFalse(t.check('10:35'));
	}
}