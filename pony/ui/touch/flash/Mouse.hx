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
package pony.ui.touch.flash;

import flash.events.MouseEvent;
import flash.Lib;
import pony.time.DeltaTime;
import pony.ui.touch.Mouse as M;
import pony.ui.touch.MouseButton;

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Mouse {

	private static var enabled:Bool = true;
	
	@:extern inline public static function init():Void {
		DeltaTime.fixedUpdate.once(initNow, -2);
	}
	
	public static function initNow():Void {
		hackMove();
		hackDown();
		hackUp();
		disableStd();
	}
	
	@:extern inline private static function hackMove():Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, false, -999);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler, true, -999);
	}
	
	
	private static function moveHandler(event:MouseEvent):Void {
		M.moveHandler(event.stageX, event.stageY);
		tlock(event);
	}
	
	@:extern inline private static function hackDown():Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, false, -999);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, downHandler, true, -999);
	}
	
	private static function downHandler(event:MouseEvent):Void {
		if (M.checkDown(MouseButton.LEFT))
			M.downHandler(event.stageX, event.stageY, MouseButton.LEFT);
		tlock(event);
	}
	
	@:extern inline private static function hackUp():Void {
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler, false, -999);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, upHandler, true, -999);
	}
	
	private static function upHandler(event:MouseEvent):Void {
		if (M.checkUp(MouseButton.LEFT))
			M.upHandler(event.stageX, event.stageY, MouseButton.LEFT);
		tlock(event);
	}
	
	public static function enableStd():Void {
		enabled = true;
		Lib.current.stage.removeEventListener(MouseEvent.CLICK, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.DOUBLE_CLICK, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_CLICK, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.MIDDLE_MOUSE_UP, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_OUT, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_OVER, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.RIGHT_CLICK, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_DOWN, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.RIGHT_MOUSE_UP, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.ROLL_OUT, lock, true);
		Lib.current.stage.removeEventListener(MouseEvent.ROLL_OVER, lock, true);
	}
	public static function disableStd():Void {
		enabled = false;
		Lib.current.stage.addEventListener(MouseEvent.CLICK, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.DOUBLE_CLICK, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.MIDDLE_CLICK, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_OUT, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_OVER, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.RIGHT_CLICK, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.RIGHT_MOUSE_UP, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.ROLL_OUT, lock, true, -1000);
		Lib.current.stage.addEventListener(MouseEvent.ROLL_OVER, lock, true, -1000);
	}

	private static function lock(event:MouseEvent):Void event.stopImmediatePropagation();
	@:extern inline private static function tlock(event:MouseEvent):Void if (!enabled) event.stopImmediatePropagation();
	
}