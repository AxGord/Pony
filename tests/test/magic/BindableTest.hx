package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Bindable;

class BindableTest 
{
	@Test
	public function testExample():Void
	{
		var b:Bindable<Int> = new Bindable(0);
		b << 5;
		Assert.areEqual(b.value, 5);
		var v = 0;
		b << (function(val) v = val) << 7;
		Assert.areEqual(v, 7);
		Assert.areEqual(b.value, 7);
	}
}