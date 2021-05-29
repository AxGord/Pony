package text;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

using pony.text.TextTools;

class TextToolsTest {

	@Test
	public function testTab(): Void {
		var data = 'lvl1
		lvl2
		lvl2b';
		var r: Map<String, Dynamic> = TextTools.tabParser(data);
		Assert.areEqual(r['lvl1'][0], 'lvl2');
		Assert.areEqual(r['lvl1'][1], 'lvl2b');
	}

	@Test
	public function startWith(): Void {
		Assert.areEqual('abcd'.startWith('ab'), true);
		Assert.areEqual('ab'.startWith('ab'), true);
		Assert.areEqual('a'.startWith('ab'), false);
		Assert.areEqual('acbn'.startWith('ab'), false);
	}

	@Test
	public function endWith(): Void {
		Assert.areEqual('abcd'.endWith('cd'), true);
		Assert.areEqual('ab'.endWith('cd'), false);
		Assert.areEqual('a'.endWith('a'), true);
		Assert.areEqual('acbn'.endWith('n'), true);
	}

}