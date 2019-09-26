package events;

import pony.events.SignalControllerInner1;
import pony.events.SignalController1;
import pony.events.SignalController0;
import pony.events.SignalController;
import pony.events.SignalControllerInner0;
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
		l.call(new SignalControllerInner0(null));
		Assert.isTrue(b);
	}
	
	@Test
	public function arg():Void
	{
		var b: Bool = false;
		var l: Listener1<Bool> = function(f: Bool, c: SignalController): Void {
			b = !f;
			if (f) c.stop();
		}
		var c: SignalControllerInner1<Bool> = new SignalControllerInner1<Bool>(null);
		l.call(false, c);
		Assert.isFalse(c.stop);
		Assert.isTrue(b);
		l.call(true, c);
		Assert.isTrue(c.stop);
		Assert.isFalse(b);
	}
	
	@Test
	public function enumTest():Void {
		var l:Listener1<L> = enumHandler;
		var c: SignalControllerInner1<L> = new SignalControllerInner1<L>(null);
		l.call(L.B, c);
		Assert.areEqual(tl, L.B);
	}
	
	private function enumHandler(l:L):Void {
		tl = l;
	}
	
}