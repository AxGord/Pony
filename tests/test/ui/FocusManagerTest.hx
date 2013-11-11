package ui;

import massive.munit.util.Timer;
import massive.munit.Assert;
import massive.munit.async.AsyncFactory;
import pony.events.Signal;
import pony.ui.FocusManager;
import pony.ui.IFocus;
import ui.FocusManagerTest.Element;

class FocusManagerTest 
{
	@Test
	public function test():Void
	{
		var elements:Array<Element> = [for (_ in 0...5) new Element()];
		elements[0].focus.dispatch(true);
		Assert.areEqual(elements[0], FocusManager.current);
		elements[2].focus.dispatch(true);
		Assert.areEqual(elements[2], FocusManager.current);
	}
}

class Element implements IFocus {
	public var focus(default,null):Signal;
	public var focusPriority(default, null):Int = 0;
	public var focusGroup(default, null):String = 'default';
	
	public function new() {
		focus = new Signal(this);
		FocusManager.reg(this);
	}
}