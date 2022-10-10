package ui;

import massive.munit.Assert;

import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.ui.keyboard.Key;
import pony.ui.keyboard.Keyboard;
import pony.ui.keyboard.IKeyboard;

class KeyboardTest {

	var helper: KeyboardTestHelper;

	@Before
	public function setup(): Void {
		helper = new KeyboardTestHelper();
		Reflect.setField(Keyboard, 'km', helper);
	}

	@After
	public function end(): Void {
		Keyboard.click.clear();
		Keyboard.down.clear();
		Keyboard.up.clear();
	}

	@Test
	public function down(): Void {
		var kb = false;
		var kc = false;
		Keyboard.down.sub(Key.B).add(function() kb = true);
		Keyboard.down.sub(Key.C).add(function() kc = true);
		helper._down(Key.B);
		Assert.isTrue(kb);
		Assert.isFalse(kc);
		helper._down(Key.C);
		Assert.isTrue(kb);
		Assert.isTrue(kc);
	}

	@Test
	public function up(): Void {
		var kb = false;
		var kc = false;
		Keyboard.up.sub(Key.B).add(function() kb = true);
		Keyboard.up.sub(Key.C).add(function() kc = true);
		helper._up(Key.B);
		Assert.isTrue(kb);
		Assert.isFalse(kc);
		helper._up(Key.C);
		Assert.isTrue(kb);
		Assert.isTrue(kc);
	}

	@Test
	public function click(): Void {
		var kb = false;
		var kc = false;
		Keyboard.click.sub(Key.B).add(function() kb = true);
		Keyboard.click.sub(Key.C).add(function() kc = true);
		helper._down(Key.B);
		Assert.isFalse(kb);
		Assert.isFalse(kc);
		helper._up(Key.B);
		helper._down(Key.C);
		Assert.isTrue(kb);
		Assert.isFalse(kc);
		helper._up(Key.C);
		Assert.isTrue(kb);
		Assert.isTrue(kc);
	}

}

class KeyboardTestHelper implements IKeyboard implements HasSignal {

	@:auto public var down: Signal1<Key>;
	@:auto public var up: Signal1<Key>;
	@:auto public var input: Signal1<UInt>;
	
	public var preventDefault: Bool = true;

	public function new() disable();

	public function enable(): Void {} // down.silent = false;

	public function disable(): Void {} // down.silent = true;

	public function _up(k: Key): Void eUp.dispatch(k);

	public function _down(k: Key): Void eDown.dispatch(k);

}