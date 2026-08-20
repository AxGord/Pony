package magic;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;
import pony.magic.HasLink;

class HasLinkTest implements HasLink {

	private static var index: Int;
	private static var visualIndex(link, never): String = '${index + 1}';

	@Test
	public function test(): Void {
		index = 5;
		Assert.areEqual(visualIndex, '6');
		index = 10;
		Assert.areEqual(visualIndex, '11');
	}

}
