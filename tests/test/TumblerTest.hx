package;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;
import pony.Tumbler;

class TumblerTest {

	@Test
	public function test(): Void {
		var on: Bool = false;
		var off: Bool = false;
		final t: Tumbler = new Tumbler();
		t.onEnable.add(function() on = true);
		t.onDisable.add(function() off = true);
		t.enabled = false;
		Assert.isFalse(on);
		Assert.isTrue(off);
		t.enabled = true;
		Assert.isTrue(on);
		Assert.isTrue(off);
	}

}
