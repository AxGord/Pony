import massive.munit.Assert;
import pony.Logable;

class LogableTest {

	@Test
	public function complex(): Void {
		final first: Logable = new Logable('First');
		final second: Logable = new Logable('Second');
		second.listenErrorAndLog(first);
		var msg: String = '';
		function writeMsg(s: String): Void msg += s;
		second.onLog << writeMsg;
		first.log('a ');
		second.onLog >> writeMsg;
		first.log('b ');
		second.onLog << writeMsg;
		first.log('c');
		Assert.areEqual('Second First a Second First c', msg);
	}

}
