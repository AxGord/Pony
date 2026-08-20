package events;

import massive.munit.Assert;
import pony.events.Listener0;
import pony.events.Listener1;
import pony.events.SignalController;
import pony.events.SignalControllerInner0;
import pony.events.SignalControllerInner1;

enum L {
	A;
	B;
	C;
}

class ListenerTest {

	private var tl: L = null;

	@Test
	public function empty(): Void {
		var b: Bool = false;
		final l: Listener0 = function() b = true;
		l.call(new SignalControllerInner0(null));
		Assert.isTrue(b);
	}

	@Test
	public function arg(): Void {
		var b: Bool = false;
		final l: Listener1<Bool> = function(f: Bool, c: SignalController): Void {
			b = !f;
			if (f) c.stop();
		}
		final c: SignalControllerInner1<Bool> = new SignalControllerInner1<Bool>(null);
		l.call(false, c);
		Assert.isFalse(c.stop);
		Assert.isTrue(b);
		l.call(true, c);
		Assert.isTrue(c.stop);
		Assert.isFalse(b);
	}

	@Test
	public function enumTest(): Void {
		final l: Listener1<L> = enumHandler;
		final c: SignalControllerInner1<L> = new SignalControllerInner1<L>(null);
		l.call(L.B, c);
		Assert.areEqual(tl, L.B);
	}

	private function enumHandler(l: L): Void {
		tl = l;
	}

}
