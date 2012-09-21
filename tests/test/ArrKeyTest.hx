package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.ArrKey;

/**
* Auto generated MassiveUnit Test Class  for pony.ArrKey 
*/
class ArrKeyTest 
{
	var d:ArrKey < Int, String > ; 
	
	@Before
	public function before():Void
	{
		d = new ArrKey < Int, String > ();
		d.set([1, 1], 'a');
		d.set([1, 2], 's');
		d.set([2, 1], 'd');
	}
	
	@Test
	public function get():Void
	{
		Assert.areEqual(d.get( [2, 1] ), 'd');
		Assert.areEqual(d.get( [1, 2] ), 's');
		Assert.areEqual(d.get( [1, 1] ), 'a');
	}
}