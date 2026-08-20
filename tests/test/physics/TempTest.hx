package physics;

import massive.munit.Assert;
import pony.physics.TempInterval;

class TempTest {

	@Test
	public function testExample(): Void {
		final t: TempInterval = '5C...8C';
		Assert.areEqual(t.mid.c, 6.5);
	}

}
