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
package pony.ui.touch.starling.touchManager.touchInputs;
import flash.events.MouseEvent;
import flash.Lib;
import flash.Vector;
import pony.ui.touch.starling.touchManager.TouchManager;
import starling.display.DisplayObject;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import pony.ui.touch.starling.touchManager.InputMode;

/**
 * ...
 * @author Maletin
 */
class StarlingTouchInput
{
	private var _displayObject:DisplayObject;
	
	public function new(displayObject:DisplayObject) 
	{
		_displayObject = displayObject;
		
		InputMode.init();
		
		_displayObject.addEventListener(TouchEvent.TOUCH, onTouch);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
	}
	
	private function onTouch(e:TouchEvent):Void
	{
		var touches:Vector<Touch> = e.getTouches(cast(e.target, DisplayObject));
		for (i in 0...touches.length)
		{		
			var touch:Touch = touches[i];
			
			if (touch == null) return;

			if (touch.phase == TouchPhase.BEGAN)
			{
				TouchManager.down(touch.globalX, touch.globalY, InputMode.touchMode(), touch.id);
			}
			
			if (touch.phase == TouchPhase.ENDED)
			{
				TouchManager.up(touch.globalX, touch.globalY, InputMode.touchMode(), touch.id);
			}
			
			
			if ( (touch.phase == TouchPhase.MOVED) ||
				( (touch.phase == TouchPhase.HOVER) && (!InputMode.touchMode()) ) )
			{
				TouchManager.move(touch.globalX, touch.globalY, InputMode.touchMode(), touch.id);
			}
		}
	}
	
	private function onMouseWheel(e:MouseEvent):Void
	{
		TouchManager.mouseWheel(e.delta);
	}	
}