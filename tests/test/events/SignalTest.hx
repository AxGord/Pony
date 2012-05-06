package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Event;
import pony.events.Listener;
import pony.events.Signal;

import pony.Ultra;
using pony.Ultra;

/**
* Auto generated MassiveUnit Test Class  for pony.events.Signal 
*/
class SignalTest 
{
	var instance:Signal; 
	
	@Before
	public function setup():Void
	{
		instance = new Signal();
	}
	
	@After
	public function tearDown():Void
	{
	}
	
	
	@Test
	public function callTest():Void
	{
		var i:Int = 0;
		var j:Int = 0;
		var a:Int = 0;
		instance.addListener(function(n:Int, Void) i = n*2);
		instance.addListener(function(Void, Void) j = 15, 1);
		instance.addListener(function(event:Event) a = event.arg(0)+1);
		instance.dispatch(27, 6);
		Assert.areEqual(54, i);
		Assert.areEqual(15, j);
		Assert.areEqual(28, a);
	}
	
	@Test
	public function invertStyle():Void {
		var b:Bool = false;
		var l:Listener = new Listener(function() b = true);
		var s:Signal = new Signal();
		l.addSignal(s);
		s.dispatch();
		Assert.isTrue(b);
	}
	
	@Test
	public function results():Void {
		instance.addListener(function(event:Event) event.results.set('bibi', 'hi'));
		Assert.areEqual('hi', instance.dispatch().results.get('bibi'));
	}
	
	@AsyncTest
	public function resultsWithDelay(factory:AsyncFactory):Void {
		instance.addListener(function(event:Event) event.results.set('bibi', 'hi'), 0, 0, 5);
		var r:Hash<Dynamic> = instance.dispatch().results;
		var handler:Dynamic = factory.createHandler(this, function() Assert.areEqual('hi', r.get('bibi')), 100);
		Timer.delay(handler, 30);
	}
	
	@Test
	public function lHandlerCall():Void {
		var l:Listener = new Listener(function() return 123);
		Assert.areEqual(123, l.handler());
	}
}