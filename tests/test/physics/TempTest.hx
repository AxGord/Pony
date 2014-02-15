package physics;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Interval;
import pony.physics.Temp;
import pony.physics.TempInterval;

class TempTest 
{
	@Test
	public function testExample():Void
	{
		var t:TempInterval = '5C...8C';
		Assert.areEqual(t.mid.c, 6.5);
	}
}