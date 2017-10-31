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
package pony.ui.touch.starling.touchManager;
import pony.ui.gui.ButtonCore;

/**
 * ...
 * @author Maletin
 */
class ButtonCoreTM extends ButtonCore
{

	public function new(object:Dynamic) 
	{
		super();
		
		TouchManager.addListener(object, touchManagerListener);
	}
	
	public function touchManagerListener(e:TouchManagerEvent):Void
	{		
		eventsTransition(e, this);
	}
	
	public static function eventsTransition(e:TouchManagerEvent, core:ButtonCore):Void
	{
		switch (e.type)
		{
			case Hover:
				core.mouseOver(false);
			case Over:
				core.mouseDown();
				core.mouseOver(true);
			case Down:
				core.mouseOver(false);
				core.mouseDown();
			case Up:
				core.mouseUp();
				core.mouseOut();
			case Out:
				core.mouseOut();
				core.mouseUp();
				core.mouseOver(false);
			case HoverOut:
				core.mouseOut();
			default:
		}
	}
	
}