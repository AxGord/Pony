package ;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.Priority;
/**
* Auto generated MassiveUnit Test Class  for pony.Priority
*/
class PriorityTest
{
	var p1:Priority<Int>;
	var p2:Priority<Int>;
	var p3:Priority<Int>;

	@Before
	public function setup():Void
	{
		p1 = new Priority<Int>();
		p2 = new Priority<Int>();
		p2.add(3, 0);
		p2.add(4, 0);
		p2.add(5, 1);
		p2.add(6, 1);
		p2.add(1, -1);
		p2.add(2, -1);
		p3 = new Priority<Int>();
		p3.add(99, 0);
	}


	@Test
	public function lenght():Void {
		Assert.areEqual(0, p1.length);
		Assert.areEqual(6, p2.length);
		Assert.areEqual(1, p3.length);
	}

	@Test
	public function empty():Void {
		for (e in p1)
			Assert.fail('empty?');
		Assert.isTrue(p1.empty);
		Assert.isFalse(p2.empty);
		Assert.isFalse(p3.empty);
	}

	@Test
	public function sort():Void {
		var i:Int = 1;
		for (e in p2) {
			Assert.areEqual(i++, e);
		}
	}

	@Test
	public function linean():Void {
		var p:Priority<Int> = new Priority<Int>();
		for (i in -50...50) {
			p.add(i, i);
		}
		var prev:Null<Int> = null;
		for (e in p) {
			if (prev != null && prev > e)
				Assert.fail('Prev > now: '+prev+', '+e);
			else
				prev = e;
		}
	}

	@Test
	public function random():Void {
		var p:Priority<Int> = new Priority<Int>();
		for (i in 0...100) {
			var r:Int = Math.round(Math.random()*10)-5;
			p.add(r, r);
		}
		var prev:Null<Int> = null;
		for (e in p) {
			if (prev != null && prev > e)
				Assert.fail('Prev > now: '+prev+', '+e);
			else
				prev = e;
		}
	}

	@Test
	public function remove():Void {
		p2.remove(5);
		Assert.areEqual(5, p2.length);
		var i:Int = 1;
		for (e in p2) {
			if (i == 5) i++;//after 4 begin 6
			Assert.areEqual(i++, e);
		}
	}

	@Test
	public function exists():Void {
		Assert.isTrue(p2.exists(5));
		Assert.isFalse(p2.exists(9));
	}

	@Test
	public function clear():Void {
		p2.clear();
		Assert.areEqual(0, p2.length);
		for (e in p2)
			Assert.fail('empty?');
	}

	@Test
	public function search():Void {
		Assert.isTrue(p2.existsFunction(function(o:Int) return o == 2));
		Assert.isFalse(p2.existsFunction(function(o:Int) return o == -8));
	}

	@Test
	public function first():Void {
		Assert.areEqual(1, p2.first);
		Assert.areEqual(99, p3.first);
	}

	@Test
	public function loop():Void {
		Assert.areEqual(1, p2.loop());
		Assert.areEqual(2, p2.loop());
		Assert.areEqual(3, p2.loop());
		Assert.areEqual(4, p2.loop());
		Assert.areEqual(5, p2.loop());
		Assert.areEqual(6, p2.loop());
		Assert.areEqual(1, p2.loop());
		Assert.areEqual(2, p2.loop());
		Assert.areEqual(3, p2.loop());
	}

	@Test
	public function loop_add():Void {
		Assert.areEqual(1, p2.loop());
		Assert.areEqual(2, p2.loop());
		p2.add(9, -1);
		Assert.areEqual(9, p2.loop());
		Assert.areEqual(3, p2.loop());
		p2.add(8, -2);
		Assert.areEqual(4, p2.loop());
		Assert.areEqual(5, p2.loop());
		Assert.areEqual(6, p2.loop());
		Assert.areEqual(8, p2.loop());
		Assert.areEqual(1, p2.loop());
		Assert.areEqual(2, p2.loop());
		Assert.areEqual(9, p2.loop());
	}

	@Test
	public function loop_remove():Void {
		Assert.areEqual(1, p2.loop());
		Assert.areEqual(2, p2.loop());
		p2.remove(3);
		Assert.areEqual(4, p2.loop());
		Assert.areEqual(5, p2.loop());
		p2.remove(1);
		Assert.areEqual(6, p2.loop());
		Assert.areEqual(2, p2.loop());
		Assert.areEqual(4, p2.loop());
	}

	@Test
	public function extrem():Void {

		var i:Int = 1;
		for (e in p2) {
			//trace(i + ' ' + e);
			switch (i++) {
				case 1: p2.remove(1);
				case 2: Assert.areEqual(2, e);
				case 3:
					Assert.areEqual(3, e);
					p2.add(11, -2);
				case 4: Assert.areEqual(4, e);
			}
		}
		Assert.areEqual(6, i-1);
	}

	@Test
	public function addToBegin():Void {
		p2.addToBegin(78);
		Assert.areEqual(78, p2.first);
	}

	@Test
	public function addToEnd():Void {
		p2.addToEnd(45);
		Assert.areEqual(45, p2.last);
	}

	@Test
	public function addArray():Void {
		var p:Priority<Int> = new Priority<Int>();
		p.addArray([4, 5, 6]);
		p.addArray([1, 2, 3], -4);
		var i:Int = 1;
		for (e in p)
			Assert.areEqual(i++, e);
		Assert.areEqual(i, 7);
	}

	@Test
	public function existsArray():Void {
		Assert.isTrue(p2.existsArray([10, 6]));
		Assert.isFalse(p2.existsArray([10, 11]));
	}

	@Test
	public function loopTest():Void {
		var p:Priority<Int> = new Priority<Int>([3]);
		Assert.areEqual(p.loop(), 3);
		Assert.areEqual(p.loop(), 3);
		Assert.areEqual(p.loop(), 3);
		Assert.areEqual(p.loop(), 3);
	}

	@Test
	public function addBigp():Void {
		var p:Priority<Int> = new Priority<Int>();
		p.add(4, 1005001005);
		p.add(6);
		Assert.areEqual(p.first, 6);
		Assert.areEqual(p.last, 4);
	}

	@Test
	public function many():Void {
		var p:Priority<Int> = new Priority<Int>();
		for (i in 0...500) p.add(i,10000+i);
		var i = 0;
		for (e in p) Assert.areEqual(e, i++);
	}

	@Test
	public function getPriority():Void {
		Assert.areEqual(p2.getPriority(3), 0);
		Assert.areEqual(p2.getPriority(4), 0);
		Assert.areEqual(p2.getPriority(5), 1);
		Assert.areEqual(p2.getPriority(6), 1);
		Assert.areEqual(p2.getPriority(1), -1);
		Assert.areEqual(p2.getPriority(2), -1);
	}

	@Test
	public function someProblemWithRemoveElementFromHash():Void {
		var p:Priority<String> = new Priority<String>();
		p.add('E', 50);
		p.add('P', 29);

		p.remove('P');
		p.remove('E');

		p.add('Ch', 1);
		p.add('P', 29);
		p.add('E', 50);
		Assert.areEqual(p.first, 'Ch');
	}

}