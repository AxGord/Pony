package;

import massive.munit.Assert;
import pony.Stream;

class StreamTest {

	@Test
	public function afterTake(): Void {
		final a: Array<Bool> = [false, false, false];
		var e: Bool = false;
		final s: Stream<Int> = new Stream<Int>();
		s.take((d: Int) -> a[d] = true, function() e = true);
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
	public function beforeTake(): Void {
		final a: Array<Bool> = [false, false, false];
		var e: Bool = false;
		final s: Stream<Int> = new Stream<Int>();
		s.dataListener(0);
		s.dataListener(1);
		s.dataListener(2);
		s.endListener();
		s.take((d: Int) -> a[d] = true, function() e = true);
		Assert.isTrue(a[0]);
		Assert.isTrue(a[1]);
		Assert.isTrue(a[2]);
		Assert.isTrue(e);
	}

	@Test
	public function mapAfter(): Void {
		final a: Array<Bool> = [false, false, false];
		var e: Bool = false;
		final s: Stream<Int> = new Stream<Int>();
		s.map(n -> n - 1).take(function(d: Int) a[d] = true, function() e = true);
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
