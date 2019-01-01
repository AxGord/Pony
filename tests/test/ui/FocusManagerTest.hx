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