package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Waiter;

import pony.Ultra;
using pony.Ultra;

class WaiterTest 
{
	
	@Test
	public function linean():Void
	{
		var r:Bool = false;
		var w:Waiter = new Waiter();
		w.wait(function() r = true);
		w.dispatch();
		Assert.isTrue(r);
	}
	
	@Test
	public function invert():Void
	{
		var r:Bool = false;
		var w:Waiter = new Waiter();
		w.dispatch();
		w.wait(function() r = true);
		Assert.isTrue(r);
	}
	
}