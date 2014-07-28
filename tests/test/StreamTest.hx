package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Stream;

class StreamTest 
{
	@Test
	public function afterTake():Void
	{
		var a = [false, false, false];
		var e = false;
		var s = new Stream<Int>();
		s.take(function(d:Int) a[d] = true, function()e=true);
		s.dataListener(0);
		s.dataListener(1);
		Assert.isTrue(a[0]);
		Assert.isTrue(a[1]);
		Assert.isFalse(a[2]);
		s.dataListener(2);
		Assert.isTrue(a[2]);
		s.endListener();
		Assert.isTrue(e);
	}
	
	@Test
	public function beforeTake():Void
	{
		var a = [false, false, false];
		var e = false;
		var s = new Stream<Int>();
		s.dataListener(0);
		s.dataListener(1);
		s.dataListener(2);
		s.endListener();
		s.take(function(d:Int) a[d] = true, function()e=true);
		Assert.isTrue(a[0]);
		Assert.isTrue(a[1]);
		Assert.isTrue(a[2]);
		Assert.isTrue(e);
	}
	@Test
	public function mapAfter():Void
	{
		var a = [false, false, false];
		var e = false;
		var s = new Stream<Int>();
		s.map(function(n) return n - 1).take(function(d:Int) a[d] = true, function() e=true);
		s.dataListener(1);
		s.dataListener(2);
		Assert.isTrue(a[0]);
		Assert.isTrue(a[1]);
		Assert.isFalse(a[2]);
		s.dataListener(3);
		Assert.isTrue(a[2]);
		s.endListener();
		Assert.isTrue(e);
	}
}