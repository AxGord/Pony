package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Dictionary;

/**
* Auto generated MassiveUnit Test Class  for pony.Dictionary 
*/
class DictionaryTest 
{
	var d:Dictionary<String, String>;
	
	@Before
	public function before():Void
	{
		d = new Dictionary<String, String>();
		d.set('q', 'a');
		d.set('w', 's');
		d.set('e', 'd');
	}
	
	@Test
	public function get():Void
	{
		Assert.areEqual(d.get('q'), 'a');
		Assert.areEqual(d.get('w'), 's');
		Assert.areEqual(d.get('e'), 'd');
	}
	
	@Test
	public function exists():Void
	{
		Assert.isTrue(d.exists('w'));
		Assert.isFalse(d.exists('j'));
	}
	
	@Test
	public function iter():Void
	{
		var i:Int = 0;
		for (v in d)
			switch (i++) {
				case 0: Assert.areEqual(v, 'a');
				case 1: Assert.areEqual(v, 's');
				case 2: Assert.areEqual(v, 'd');
			}
		Assert.areEqual(i, 3);
	}
	
	@Test
	public function iterkeys():Void
	{
		var i:Int = 0;
		for (k in d.keys())
			switch (i++) {
				case 0: Assert.areEqual(k, 'q');
				case 1: Assert.areEqual(k, 'w');
				case 2: Assert.areEqual(k, 'e');
			}
		Assert.areEqual(i, 3);
	}
	
	@Test
	public function toString():Void
	{
		Assert.areEqual(d.toString(), '[q: a, w: s, e: d]');
	}
	
	@Test
	public function remove():Void
	{
		d.remove('w');
		var i:Int = 0;
		for (v in d)
			switch (i++) {
				case 0: Assert.areEqual(v, 'a');
				case 1: Assert.areEqual(v, 'd');
			}
		Assert.areEqual(i, 2);
		i = 0;
		for (k in d.keys())
			switch (i++) {
				case 0: Assert.areEqual(k, 'q');
				case 1: Assert.areEqual(k, 'e');
			}
		Assert.areEqual(i, 2);
	}
	
	@Test
	public function floatAsKey():Void {
		var d:Dictionary<Float,String> = new Dictionary<Float,String>();
		d.set(0.66, 'qwe');
		d.set(0.88, 'asd');
		Assert.areEqual(d.get(0.66), 'qwe');
		Assert.areEqual(d.get(0.88), 'asd');
	}
	
	
}