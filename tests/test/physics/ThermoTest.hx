package physics;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.DeltaTime;
import pony.physics.Thermo;

using pony.Tools;

class ThermoTest 
{
	
	@Test
	public function hour():Void
	{
		var t = new Thermo();
		t.tempTarget = 40;
		DeltaTester.run(60 * 60);
		//trace(t.temp);
		//trace(t.kwTotal);
		Assert.isTrue(t.temp.approximately(40));
		Assert.isTrue(t.kwTotal.approximately(0.3));
	}
	
	@Test
	public function min():Void
	{
		var t = new Thermo();
		t.tempTarget = 40;
		DeltaTester.run(60);
		//trace(t.temp);
		//trace(t.kwTotal);
		Assert.isTrue(t.temp.approximately(25));
		Assert.isTrue(t.kwTotal.approximately(0.06));
	}
	
	@Test
	public function pump():Void {
		var t = new Thermo();
		t.wetTarget = 0.8;
		DeltaTester.run(60);
		//trace(t.wet);
		//trace(t.kwTotal);
		Assert.isTrue(t.wet.approximately(0.8));
		Assert.isTrue(t.kwTotal.approximately(0.01));
	}
	
	@Test
	public function dehumidifier():Void {
		var t = new Thermo();
		t.wetTarget = 0.3;
		DeltaTester.run(60);
		//trace(t.wet);
		//trace(t.kwTotal);
		Assert.isTrue(t.wet.approximately(0.4));
		Assert.isTrue(t.kwTotal.approximately(0.03));
		
	}
}