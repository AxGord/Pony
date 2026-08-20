package ui;

import massive.munit.Assert;
import pony.time.DeltaTime;
import pony.ui.Presser;

class PresserTest {

	@Test
	public function delta(): Void {
		var c: Int = 0;
		final p: Presser = new Presser(() -> c++);
		Assert.areEqual(c, 0);
		DeltaTime.testRun(550);
		Assert.areEqual(c, 1);
		DeltaTime.testRun(650);
		Assert.areEqual(c, 4);
		p.destroy();
		DeltaTime.testRun(600);
		Assert.areEqual(c, 4);
	}

}
