package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Tumbler;

class TumblerTest 
{
	@Test
	public function test():Void
	{
		var on:Bool = false;
		var off:Bool = false;
		var t = new Tumbler();
		t.onEnable.add(function() on = true);
		t.onDisable.add(function() off = true);
		Assert.isFalse(on);
		Assert.isFalse(off);
		t.enabled = true;
		Assert.isTrue(on);
		Assert.isFalse(off);
		t.enabled = false;
		Assert.isTrue(on);
		Assert.isTrue(off);
	}
	
}