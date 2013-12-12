package ui;

import massive.munit.Assert;
import pony.events.Signal;
import pony.events.Signal1;
import pony.ui.Key;
import pony.ui.Keyboard;
import pony.ui.IKeyboard;
class KeyboardTest 
{
	var helper:KeyboardTestHelper;

	@Before
	public function setup():Void
	{
		helper = new KeyboardTestHelper();
		Reflect.setField(Keyboard, 'km', helper);
	}
	
	@After
	public function end():Void {
		Keyboard.down.removeAllListeners();
		Keyboard.up.removeAllListeners();
	}
	
	@Test
	public function down():Void
	{
		var kb = false;
		var kc = false;
		Keyboard.down.sub(Key.B).add(function() kb = true);
		Keyboard.down.sub(Key.C).add(function() kc = true);
		helper.down.dispatch(Key.B);
		Assert.isTrue(kb);
		Assert.isFalse(kc);
		helper.down.dispatch(Key.C);
		Assert.isTrue(kb);
		Assert.isTrue(kc);
	}
}

class KeyboardTestHelper implements IKeyboard<KeyboardTestHelper> {
	
	public var down(default, null):Signal1<KeyboardTestHelper, Key>;
	public var up(default, null):Signal1<KeyboardTestHelper, Key>;

	public function new() {
		down = Signal.create(this);
		up = Signal.create(this);
	}
	
	public function enable():Void {
		//trace('enable');
	}
	public function disable():Void {
		//trace('disable');
	}
	
}