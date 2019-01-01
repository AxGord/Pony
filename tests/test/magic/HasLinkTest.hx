package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.HasLink;

class HasLinkTest implements HasLink
{
	
	static var index:Int;
	static var visualIndex(link, never):String = Std.string(index + 1);
	
	@Test
	public function test():Void
	{
		index = 5;
		Assert.areEqual(visualIndex, '6');
		index = 10;
		Assert.areEqual(visualIndex, '11');
	}
}