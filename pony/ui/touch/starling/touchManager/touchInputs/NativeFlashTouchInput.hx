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
package pony.ui.touch.starling.touchManager.touchInputs;
import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import pony.ui.touch.starling.touchManager.InputMode;
import pony.ui.touch.starling.touchManager.TouchManager;

/**
 * ...
 * @author Maletin
 */
class NativeFlashTouchInput
{
	private var _displayObject:DisplayObject;

	public function new(displayObject:DisplayObject) 
	{
		_displayObject = displayObject;
		
		InputMode.init();
		
		_displayObject.addEventListener(MouseEvent.MOUSE_UP, onUp);
		_displayObject.addEventListener(MouseEvent.MOUSE_DOWN, onDown);
		_displayObject.addEventListener(MouseEvent.MOUSE_MOVE, onMove);
		_displayObject.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		
		_displayObject.addEventListener(TouchEvent.TOUCH_END, onTouchUp);
		_displayObject.addEventListener(TouchEvent.TOUCH_BEGIN, onTouchDown);
		_displayObject.addEventListener(TouchEvent.TOUCH_MOVE, onTouchMove);
	}
	
	private function onUp(e:MouseEvent):Void
	{
		if (!InputMode.touchMode())
		{
			TouchManager.up(e.stageX, e.stageY, false);
			TouchManager.move(e.stageX, e.stageY, false);
		}
	}
	
	private function onDown(e:MouseEvent):Void
	{
		if (!InputMode.touchMode())
		{
			TouchManager.down(e.stageX, e.stageY, false);
		}
	}
	
	private function onMove(e:MouseEvent):Void
	{
		if (!InputMode.touchMode())
		{
			TouchManager.move(e.stageX, e.stageY, false, 0, e.buttonDown);
		}
	}
	
	private function onMouseWheel(e:MouseEvent):Void
	{
		TouchManager.mouseWheel(e.delta);
	}
	
	private function onTouchUp(e:TouchEvent):Void
	{
		if (InputMode.touchMode())
		{
			TouchManager.up(e.stageX, e.stageY, true, e.touchPointID);
		}
	}
	
	private function onTouchDown(e:TouchEvent):Void
	{
		if (InputMode.touchMode())
		{
			TouchManager.down(e.stageX, e.stageY, true, e.touchPointID);
		}
	}
	
	private function onTouchMove(e:TouchEvent):Void
	{
		if (InputMode.touchMode())
		{
			TouchManager.move(e.stageX, e.stageY, true, e.touchPointID);
		}
	}
	
}