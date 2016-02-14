package math;

import pony.math.MathTools;

using massive.munit.Assert;

class MathToolsTest 
{
	
	@Test
	public function testRange():Void
	{
		MathTools.range(3, 7).areEqual(4);
		MathTools.range(-2, 3).areEqual(5);
		MathTools.range(4, 1).areEqual(3);
		MathTools.range(1, -8).areEqual(9);
		MathTools.range(-1, -8).areEqual(7);
	}
	
}