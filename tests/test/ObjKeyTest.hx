package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.ObjKey;

/**
* Auto generated MassiveUnit Test Class  for pony.ObjKey 
*/
class ObjKeyTest 
{
	var d:ObjKey<Obj, String>; 
	@Before
	public function before():Void
	{
		d = new ObjKey<Obj, String>();
		d.set({s: 'q', i: 1}, 'a');
		d.set({s: 'w', i: 2}, 's');
		d.set({s: 'w', i: 1}, 'd');
	}
	
	@Test
	public function get():Void
	{
		Assert.areEqual(d.get( { s: 'w', i: 1 } ), 'd');
		Assert.areEqual(d.get( { s: 'w', i: 2 } ), 's');
		Assert.areEqual(d.get( { s: 'q', i: 1 } ), 'a');
	}
}

typedef Obj = {
	s: String,
	i: Int
}