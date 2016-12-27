package text;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.text.TextTools;

class TextToolsTest 
{
	@Test
	public function testTab():Void
	{
		var data = 'lvl1
		lvl2
		lvl2b';
		var r:Map<String, Dynamic> = TextTools.tabParser(data);
		Assert.areEqual(r['lvl1'][0], 'lvl2');
		Assert.areEqual(r['lvl1'][1], 'lvl2b');
	}
}