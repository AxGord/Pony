package ui;

import massive.munit.Assert.*;
import pony.ui.gui.ButtonCore;

class ButtonCoreTest 
{
	var instance:ButtonCore; 
	
	@Before
	public function setup():Void
	{
		//todo: need toucheble test object
		//instance = new ButtonCore();
	}
	/*
	@Test
	public function mouseVisual():Void
	{
		areEqual(instance.visualState, Default);
		instance.mouseOver(true);
		areEqual(instance.visualState, Default);
		
		instance.mouseOut();
		instance.mouseOver(false);
		areEqual(instance.visualState, Focus);
		instance.mouseOut();
		areEqual(instance.visualState, Default);
		
		instance.mouseDown();
		areEqual(instance.visualState, Default);
		instance.mouseUp();
		areEqual(instance.visualState, Default);
		
		instance.mouseOver(false);
		instance.mouseDown();
		areEqual(instance.visualState, Press);
		instance.mouseUp();
		areEqual(instance.visualState, Focus);
		instance.mouseDown();
		areEqual(instance.visualState, Press);
		instance.mouseOut();
		areEqual(instance.visualState, Leave);
		instance.mouseUp();
		areEqual(instance.visualState, Default);	
	}
	*/
}