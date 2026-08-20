package fs;

import massive.munit.Assert;
import pony.fs.Dir;

class UnitTest {

	#if (neko || cpp || nodejs)
	@Test
	public function test(): Void {
		final v: Dir = '.';
		Assert.areEqual(v.toString(), '.');
	}
	#end

}
