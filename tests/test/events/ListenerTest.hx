package events;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Listener0;
import pony.events.Listener1;

enum L { A; B; C; }

class ListenerTest 
{
	
	private var tl:L = null;
	
	@Test
	public function empty():Void
	{
		var b:Bool = false;
		var l:Listener0 = function() b = true;
		l.call();
		Assert.isTrue(b);
	}
	
	@Test
	public function arg():Void
	{
		var b:Bool = false;
		var l:Listener1<Bool> = function(f:Bool) return !( b = f );
		Assert.isFalse(l.call(true));
		Assert.isTrue(b);
		Assert.isTrue(l.call(false));
		Assert.isFalse(b);
	}
	
	@Test
	public function enumTest():Void {
		var l:Listener1<L> = enumHandler;
		l.call(L.B);
		Assert.areEqual(tl, L.B);
	}
	
	private function enumHandler(l:L):Void {
		tl = l;
	}
	
}