package;

import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import massive.munit.util.Timer;
import pony.Or;

class OrTest {

	@Test
	public function test(): Void {
		Assert.areEqual(get(3), 3);
		Assert.areEqual(get([6]), 6);
		Assert.areEqual(get('3'), '3');
		Assert.areEqual(get(['6']), '6');
	}

	private static function get<T>(or: Or<Array<T>, T>): T {
		switch or {
			case OrState.A(v): return v[0];
			case OrState.B(v): return v;
		}
	}

}
