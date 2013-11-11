package events;

import events.ListenerTest.L;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Event;
import pony.events.Listener;

enum L { A; B; C; }

class ListenerTest 
{
	
	private var tl:L = null;
	
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
	
	@Test
	public function enumTest():Void {
		var l:Listener = enumHandler;
		l.call(new Event([L.B]));
		Assert.areEqual(tl, L.B);
	}
	
	private function enumHandler(l:L):Void {
		tl = l;
	}
	
}