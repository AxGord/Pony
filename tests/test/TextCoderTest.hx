package;

import massive.munit.Assert;
import pony.text.TextCoder;

class TextCoderTest {

	private var instance: TextCoder;

	@Before
	public function setup(): Void {
		instance = new TextCoder('dHD8ytwbbgoa');
	}

	@Test
	public function tests(): Void {
		Assert.areEqual(instance.encode('qwdgb9qw6f3hnmnnn'), 'V08VEFS83WS9AGA6R');
		Assert.areEqual(instance.encode('asbfhn549g2gg'), '6QPC4EU16EA8Q');
		Assert.areEqual(instance.encode(' '), null);
	}

}
