package ui;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.time.DeltaTime;
import pony.ui.Presser;

class PresserTest 
{	
	@Test
	public function delta():Void
	{
		var c = 0;
		var p = new Presser(function() c++);
		Assert.areEqual(c, 0);
		DeltaTime.testRun(600);
		Assert.areEqual(c, 1);
		DeltaTime.testRun(600);
		Assert.areEqual(c, 4);
		p.destroy();
		DeltaTime.testRun(600);
		Assert.areEqual(c, 4);
	}
	
}