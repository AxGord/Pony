/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
* 
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
* 
* 1. Redistributions of source code must retain the above copyright notice, this list of
*   conditions and the following disclaimer.
* 
* 2. Redistributions in binary form must reproduce the above copyright notice, this list
*   of conditions and the following disclaimer in the documentation and/or other materials
*   provided with the distribution.
* 
* THIS SOFTWARE IS PROVIDED BY ALEXANDER GORDEYKO ``AS IS'' AND ANY EXPRESS OR IMPLIED
* WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
* FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL ALEXANDER GORDEYKO OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
* CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
* ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
* ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**/
package ui;

import massive.munit.Assert;
import pony.events.Signal1;
import pony.magic.HasSignal;
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
		Keyboard.click.clear();
		Keyboard.down.clear();
		Keyboard.up.clear();
	}
	
	@Test
	public function down():Void
	{
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
	public function up():Void
	{
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
	public function click():Void
	{
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
	@:auto public var down:Signal1<Key>;
	@:auto public var up:Signal1<Key>;
	public function new() disable();
	public function enable():Void {}// down.silent = false;
	public function disable():Void { }// down.silent = true;
	
	public function _up(k:Key) eUp.dispatch(k);
	public function _down(k:Key) eDown.dispatch(k);
}