package physics;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.DeltaTime;
import pony.physics.Thermo;

using pony.Tools;

class ThermoTest 
{
	/* Not stable on hour
	@Test
	public function hour():Void
	{
		var t = new Thermo();
		t.enabled = true;
		t.tempTarget = 40;
		DeltaTester.run(60 * 60);
		//trace(t.temp);
		//trace(t.kwTotal);
		Assert.isTrue(t.temp.inRange(30,42));
		Assert.isTrue(t.kwTotal.approximately(2.3));
	}
	*/
	@Test
	public function min():Void
	{
		var t = new Thermo();
		t.enabled = true;
		t.tempTarget = 40;
		DeltaTime.testRun(60);
		//trace(t.temp);
		//trace(t.kwTotal);
		Assert.isTrue(t.temp.approximately(39));
		Assert.isTrue(t.kwTotal.approximately(0.062));
	}
	
	@Test
	public function pump():Void {
		var t = new Thermo();
		t.wetTarget = 0.8;
		DeltaTime.testRun(60);
		//trace(t.wet);
		//trace(t.kwTotal);
		Assert.isTrue(t.wet.approximately(0.8));
		Assert.isTrue(t.kwTotal.approximately(0.01));
	}
	
	@Test
	public function dehumidifier():Void {
		var t = new Thermo();
		t.wetTarget = 0.3;
		DeltaTime.testRun(60);
		//trace(t.wet);
		//trace(t.kwTotal);
		Assert.isTrue(t.wet.approximately(0.4));
		Assert.isTrue(t.kwTotal.approximately(0.03));
		
	}
}