package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
using pony.Tools;

class ToolsTest 
{
	
	@Test
	public function explode():Void
	{
		Assert.isTrue('1-2 3 - 4'.explode(['-',' ']).equal(['1','2','3','4']));
	}
}