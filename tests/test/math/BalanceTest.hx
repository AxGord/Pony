package math;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.math.Balance;
import pony.Tools;
import pony.math.MathTools;

class BalanceTest 
{	
	
	private var b:Balance;
	
	@Before
	public function setup():Void
	{
		b = [0.04, 0.08, 0.12];
		b.calc(3);
		//trace(b);
	}
	
	@Test
	public function add():Void
	{
		b[3] += 0.1;
		checkPositive();
		Assert.areEqual(b[0]+b[1], 0.07);
		Assert.areEqual(b[2], 0.07);
	}
	
	@Test
	public function sub():Void
	{
		b[3] -= 0.1;
		checkPositive();
		Assert.isTrue(MathTools.inRange(b[0]+b[1], 0.16, 0.18));
		Assert.isTrue(MathTools.inRange(b[2], 0.16, 0.18));
	}
	
	private function checkPositive():Void {
		for (e in b) Assert.isTrue(e >= 0);
	}
	
}