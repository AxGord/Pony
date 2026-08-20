package magic;

import massive.munit.Assert;
import pony.magic.HasLink;

class HasLinkTest implements HasLink {

	private static var visualIndex(link, never): String = '${index + 1}';
	private static var index: Int;

	@Test
	public function test(): Void {
		index = 5;
		Assert.areEqual(visualIndex, '6');
		index = 10;
		Assert.areEqual(visualIndex, '11');
	}

}
