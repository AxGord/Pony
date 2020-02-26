package events;

import pony.Tumbler;
import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

class TumblerTest {

	@Test
	public function testDisable() {
		var flag: Bool = false;
		var t: Tumbler = new Tumbler();
		t.onDisable << function() flag = true;
		t.disable();
		Assert.isTrue(flag);
	}

	@Test
	public function testEnable() {
		var flag: Bool = false;
		var t: Tumbler = new Tumbler(false);
		t.onEnable << function() flag = true;
		t.enable();
		Assert.isTrue(flag);
	}

	@Test
	public function testSet() {
		var flag: Bool = false;
		var flag2: Bool = false;
		var t: Tumbler = new Tumbler();
		t.onDisable << function() flag = true;
		t.onEnable << function() flag2 = true;
		t.enabled = !t.enabled;
		Assert.isFalse(flag2);
		Assert.isTrue(flag);
		t.enabled = !t.enabled;
		Assert.isTrue(flag2);
	}

}