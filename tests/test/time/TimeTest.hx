package time ;

import massive.munit.Assert.*;
import pony.time.Time;

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
		areEqual((n:String), '-1');
	}
}