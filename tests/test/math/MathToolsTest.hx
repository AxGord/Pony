package math;

import pony.math.MathTools;

using pony.Tools;
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

	@Test
	public function testClipSmoothFrames():Void {
		MathTools.clipSmoothFrames(4, 5).equal([4, 0, 1]).isTrue();
	}

	@Test
	public function testClipSmoothOddPlan():Void {
		MathTools.clipSmoothOddPlan(0, 5).equal([0, 1, 2]).isTrue();
		MathTools.clipSmoothOddPlan(1, 5).equal([1, 0, 3]).isTrue();
		MathTools.clipSmoothOddPlan(4, 5).equal([0, 2, 3]).isTrue();
		MathTools.clipSmoothOddPlan(3, 5).equal([1, 2, 0]).isTrue();
		MathTools.clipSmoothOddPlan(3, 4).equal([1, 0, 3]).isTrue();
		MathTools.clipSmoothOddPlan(2, 4).equal([0, 1, 2]).isTrue();
		MathTools.clipSmoothOddPlan(1, 4).equal([1, 0, 3]).isTrue();
	}

}