package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Dispatcher;

import pony.Ultra;
using pony.Ultra;

class DispatcherTest 
{
	var d:Dispatcher; 
	
	@Before
	public function setup():Void
	{
		d = new Dispatcher();
	}
	
	@Test
	public function callTest():Void
	{
		var ready1:Bool = false;
		var ready2:Bool = false;
		d.addListener('tuktuk', function() ready1 ? Assert.fail('First ready') : ready1 = true);
		d.addListener('bumbum', function() ready2 ? Assert.fail('Second ready') : ready2 = true);
		d.dispatch('tuktuk');
		d.dispatch('bumbum');
		Assert.isTrue(ready1);
		Assert.isTrue(ready2);
	}
	
}