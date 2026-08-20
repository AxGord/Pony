package;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;
import pony.Pool;
import pony.TypedPool;

class PoolTest {

	@Test
	public function testTypedPool(): Void {
		Obj.counter = 0;
		final p: TypedPool<Obj> = new TypedPool<Obj>();
		final a: Obj = p.get();
		Assert.areEqual(a.id, 0);
		final b: Obj = p.get();
		Assert.areEqual(b.id, 1);
		p.ret(a);
		final c: Obj = p.get();
		Assert.areEqual(c.id, 0);
	}

	@Test
	public function testDynPool(): Void {
		Obj.counter = 0;
		final p: Pool<Obj> = new Pool<Obj>(Obj);
		final a: Obj = p.get();
		Assert.areEqual(a.id, 0);
		final b: Obj = p.get();
		Assert.areEqual(b.id, 1);
		p.ret(a);
		final c: Obj = p.get();
		Assert.areEqual(c.id, 0);
	}

}

class Obj {

	public static var counter: Int = 0;

	public var id: Int;

	public function new() {
		id = counter++;
	}

}
