package time;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.time.DeltaTime;
import pony.time.DTimer;

class DTimerTest 
{
	@Test
	public function delay():Void
	{
		var ok = false;
		DTimer.delay('01:00', function() ok = true);
		DeltaTime.testRun('02:00');
		Assert.isTrue(ok);
	}
	
	@Test
	public function repeat():Void {
		var c = 0;
		DTimer.repeat('30sec', function() c++);
		DeltaTime.testRun('01:50');
		Assert.areEqual(c, 3);
	}
	
	@Test
	public function backTimerShort():Void {
		var c = 0;
		DTimer.createTimer('2sec', '5sec', 3).complite.add(function() c++).start();
		DeltaTime.testRun('10sec');
		Assert.areEqual(c, 4);
	}
	
	@Test
	public function backTimerLong():Void {
		var c = 0;
		DTimer.createTimer('2sec', '5sec', 3).complite.add(function() c++).start();
		DeltaTime.testRun('10h');
		Assert.areEqual(c, 4);
	}
}