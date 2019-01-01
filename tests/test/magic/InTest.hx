package magic;

import massive.munit.Assert.*;
import pony.magic.In;

class InTest implements In
{
	
	@Test
	public function test():Void
	{
		isTrue(5 in [3, 5, 7]);
		isFalse(3 in [4, 7, 8]);
		isTrue('e' in 'hello');
		isFalse('w' in 'hello');
	}
}