/**
* Copyright (c) 2012-2018 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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