package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Pool;
import pony.TypedPool;

class PoolTest 
{
	
	@Test
	public function testTypedPool():Void
	{
		Obj.counter = 0;
		var p = new TypedPool<Obj>();
		var a:Obj = p.get();
		Assert.areEqual(a.id, 0);
		var b:Obj = p.get();
		Assert.areEqual(b.id, 1);
		p.ret(a);
		var c:Obj = p.get();
		Assert.areEqual(c.id, 0);
	}
	
	@Test
	public function testDynPool():Void {
		Obj.counter = 0;
		var p = new Pool<Obj>(Obj);
		var a:Obj = p.get();
		Assert.areEqual(a.id, 0);
		var b:Obj = p.get();
		Assert.areEqual(b.id, 1);
		p.ret(a);
		var c:Obj = p.get();
		Assert.areEqual(c.id, 0);
	}
}

class Obj {
	
	public static var counter:Int = 0;
	
	public var id:Int;
	
	public function new() {
		id = counter++;
	}
	
}