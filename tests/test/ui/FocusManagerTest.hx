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

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.ui.gui.FocusManager;
import pony.ui.gui.IFocus;
import ui.FocusManagerTest.Element;

class FocusManagerTest 
{
	@Test
	public function test():Void
	{
		var elements:Array<Element> = [for (_ in 0...5) new Element()];
		elements[0].focus();
		Assert.areEqual(elements[0], FocusManager.current);
		elements[2].focus();
		Assert.areEqual(elements[2], FocusManager.current);
	}
}

class Element implements IFocus implements HasSignal {
	@:auto public var onFocus:Signal1<Bool>;
	public var focusPriority(default, null):Int = 0;
	public var focusGroup(default, null):String = 'default';
	
	public function new() {
		FocusManager.reg(this);
	}
	
	public function focus():Void eFocus.dispatch(true);
	public function unfocus():Void eFocus.dispatch(false);
}