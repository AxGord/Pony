package fs;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.fs.Dir;
import pony.fs.Unit;

class UnitTest 
{
	@Test
	public function test():Void
	{
		var v:Dir = '.';
		Assert.areEqual(v.toString(), '.');
	}
}