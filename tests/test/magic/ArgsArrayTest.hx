package magic;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.magic.ArgsArray;

class ArgsArrayTest implements ArgsArray
{
		
	@Test
	public function simple():Void
	{
		var a:Array<Dynamic> = [1, 'rt', -34];
		var r:Array<Dynamic> = f(1, 'rt', -34);
		for (e in r)
			Assert.areEqual(a.shift(), e);
	}
	
	//not static no work without constructor
	@ArgsArray static function f(a:Array<Dynamic>):Array<Dynamic> {
		return a;
	}
	
}