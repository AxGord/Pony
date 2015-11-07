package ui;

import massive.munit.Assert;
import pony.events.Signal;
import pony.events.Signal1;
import pony.ui.keyboard.Key;
import pony.ui.keyboard.Keyboard;
import pony.ui.keyboard.IKeyboard;
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
		Keyboard.click.removeAllListeners();
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
	
	@Test
	public function up():Void
	{
		var kb = false;
		var kc = false;
		Keyboard.up.sub(Key.B).add(function() kb = true);
		Keyboard.up.sub(Key.C).add(function() kc = true);
		helper.up.dispatch(Key.B);
		Assert.isTrue(kb);
		Assert.isFalse(kc);
		helper.up.dispatch(Key.C);
		Assert.isTrue(kb);
		Assert.isTrue(kc);
	}
	
	@Test
	public function click():Void
	{
		var kb = false;
		var kc = false;
		Keyboard.click.sub(Key.B).add(function() kb = true);
		Keyboard.click.sub(Key.C).add(function() kc = true);
		helper.down.dispatch(Key.B);
		Assert.isFalse(kb);
		Assert.isFalse(kc);
		helper.up.dispatch(Key.B);
		helper.down.dispatch(Key.C);
		Assert.isTrue(kb);
		Assert.isFalse(kc);
		helper.up.dispatch(Key.C);
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
		disable();
	}
	
	public function enable():Void {
		down.silent = false;
	}
	public function disable():Void {
		down.silent = true;
	}
	
}