package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;

import pony.Stream;

/**
 * ...
 * @author AxGord
 */

class StreamTest
{
	var data:Array<Int>;
	var s1:Stream<Int>;
	var s2:Stream<String>;

	@Before
	public function setup():Void
	{
		data = [2, 4, 6];
		s1 = new Stream<Int>(data, function(n:Int):Int return n+1);
		s2 = new Stream<String>(s1, function(n:Int):String return Std.string(n));
	}
	
	@Test
	public function simple() {
		Assert.areEqual('5', s2.array()[1]);
	}
	
	@Test
	public function concat() {
		var s3:Stream<String> = s2.concat(new Stream < String > (['a', 'b', 'c']));
		var r:Array<String> = s3.array();
		//trace(r);
		Assert.areEqual('b', r[4]);
		Assert.areEqual('5', r[1]);
	}
	
	@Test
	public function calc() {
		s2.calc();
		concat();
	}
	
	@Test
	public function justArray() {
		var s:Stream<Int> = new Stream(data);
		Assert.areEqual(4, s.get(1));
	}
	
}