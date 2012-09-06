package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Intervals;

/**
* Auto generated MassiveUnit Test Class  for pony.Intervals 
*/
class IntervalsTest 
{
	@Test
	public function intValue():Void
	{
		var i:Intervals = new Intervals(25);
		var it:Iterator<Int> = i.iterator();
		Assert.isTrue(it.hasNext());
		Assert.areEqual(it.next(), 25);
		Assert.isFalse(it.hasNext());
	}
	
	@Test
	public function intIterValue():Void {
		var i:Intervals = new Intervals(4...58);
		var it:Iterator<Int> = i.iterator();
		Assert.isTrue(it.hasNext());
		Assert.areEqual(it.next(), 4);
	}
	
	@Test
	public function arrayValue():Void {
		var i:Int = 0;
		for (v in new Intervals([ -1...3, 5, 7...9])) switch (i++) {
			case 0: Assert.areEqual(v, -1);
			case 1: Assert.areEqual(v, 0);
			case 2: Assert.areEqual(v, 1);
			case 3: Assert.areEqual(v, 2);
			case 4: Assert.areEqual(v, 5);
			case 5: Assert.areEqual(v, 7);
			case 6: Assert.areEqual(v, 8);
			default: Assert.fail('Out');
		}
	}
	
	@Test
	public function easyLoop():Void {
		var it:Intervals = new Intervals(7);
		Assert.areEqual(it.loop(), 7);
		Assert.areEqual(it.loop(), 7);
		Assert.areEqual(it.loop(), 7);
		Assert.areEqual(it.loop(), 7);
		Assert.areEqual(it.loop(), 7);
	}
	
	@Test
	public function loopTest():Void {
		var it:Intervals = new Intervals( -1...3);
		for (i in 0...7) {
			switch (i) {
				case 0: Assert.areEqual(it.loop(), -1);
				case 1: Assert.areEqual(it.loop(), 0);
				case 2: Assert.areEqual(it.loop(), 1);
				case 3: Assert.areEqual(it.loop(), 2);
				case 4: Assert.areEqual(it.loop(), -1);
				case 5: Assert.areEqual(it.loop(), 0);
				case 6: Assert.areEqual(it.loop(), 1);
			}
		}
	}
}