package events;

import massive.munit.Assert;
import pony.Tumbler;

class TumblerTest {

	@Test
	public function testDisable(): Void {
		var flag: Bool = false;
		final t: Tumbler = new Tumbler();
		t.onDisable << function() flag = true;
		t.disable();
		Assert.isTrue(flag);
	}

	@Test
	public function testEnable(): Void {
		var flag: Bool = false;
		final t: Tumbler = new Tumbler(false);
		t.onEnable << function() flag = true;
		t.enable();
		Assert.isTrue(flag);
	}

	@Test
	public function testSet(): Void {
		var flag: Bool = false;
		var flag2: Bool = false;
		final t: Tumbler = new Tumbler();
		t.onDisable << function() flag = true;
		t.onEnable << function() flag2 = true;
		t.enabled = !t.enabled;
		Assert.isFalse(flag2);
		Assert.isTrue(flag);
		t.enabled = !t.enabled;
		Assert.isTrue(flag2);
	}

}
