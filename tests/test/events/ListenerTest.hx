package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Event;
import pony.events.Listener;

class ListenerTest 
{
	
	@Test
	public function withEvent():Void
	{
		var b:Bool = false;
		var l:Listener = function(event:Event) b = event.args[0];
		l.call(new Event([true]));
		Assert.isTrue(b);
		l.call(new Event([false]));
		Assert.isFalse(b);
		l.unuse();
	}
	
	@Test
	public function withEventBool():Void
	{
		var b:Bool = false;
		var l:Listener = function(event:Event):Bool return !(b = event.args[0]);
		Assert.isFalse(l.call(new Event([true])));
		Assert.isTrue(b);
		Assert.isTrue(l.call(new Event([false])));
		Assert.isFalse(b);
		l.unuse();
	}
	
	@Test
	public function empty():Void
	{
		var b:Bool = false;
		var l:Listener = function() b = true;
		Assert.isTrue(l.call(new Event([true])));
		Assert.isTrue(b);
		l.unuse();
	}
	
	@Test
	public function arg():Void
	{
		var b:Bool = false;
		var l:Listener = function(f:Bool) return !( b = f );
		Assert.isFalse(l.call(new Event([true])));
		Assert.isTrue(b);
		Assert.isTrue(l.call(new Event([false])));
		Assert.isFalse(b);
		l.unuse();
	}
	
	
}