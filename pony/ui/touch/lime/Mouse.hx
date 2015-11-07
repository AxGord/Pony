/**
* Copyright (c) 2012-2015 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
*
* Redistribution and use in source and binary forms, with or without modification, are
* permitted provided that the following conditions are met:
*
*   1. Redistributions of source code must retain the above copyright notice, this list of
*      conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright notice, this list
*      of conditions and the following disclaimer in the documentation and/or other materials
*      provided with the distribution.
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
*
* The views and conclusions contained in the software and documentation are those of the
* authors and should not be interpreted as representing official policies, either expressed
* or implied, of Alexander Gordeyko <axgord@gmail.com>.
**/
package pony.ui.touch.lime;

import lime.app.Application;
import lime.app.Event;
import pony.time.DeltaTime;
import pony.ui.touch.Mouse as M;
import pony.ui.touch.MouseButton;

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Mouse {
	
	private static var moveEvent:Event<Float->Float->Void>;
	private static var downEvent:Event<Float->Float->Int->Void>;
	private static var upEvent:Event<Float->Float->Int->Void>;
	
	private static var mouseDown:Bool = false;
	
	@:extern inline public static function init():Void {
		DeltaTime.fixedUpdate.once(initNow, -2);
	}
	
	@:access(pony.ui.touch.Mouse)
	public static function initNow():Void {
		hackMove();
		hackDown();
		hackUp();
		Application.current.window.onLeave.add(function() M.eLeave.dispatch());
	}
	
	@:extern inline private static function hackMove():Void {
		moveEvent = Application.current.window.onMouseMove;
		var event:Event<Float->Float->Void> = new Event<Float->Float->Void>();
		event.add(M.moveHandler, false, 1000);
		Application.current.window.onMouseMove = event;
	}
	
	@:extern inline private static function hackDown():Void {
		downEvent = Application.current.window.onMouseDown;
		var event:Event<Float->Float->Int->Void> = new Event<Float->Float->Int->Void>();
		event.add(M.downHandler, false, 1000);
		Application.current.window.onMouseDown = event;
	}
	
	@:extern inline private static function hackUp():Void {
		upEvent = Application.current.window.onMouseUp;
		var event:Event<Float->Float->Int->Void> = new Event<Float->Float->Int->Void>();
		event.add(M.upHandler, false, 1000);
		Application.current.window.onMouseUp = event;
	}
	
	public static function enableStd():Void {
		M.onMove.add(moveEvent.dispatch, 1);
		M.onLeftDown.add(leftDown,1);
		M.onMiddleDown.add(rightDown, 1);
		M.onRightDown.add(middleDown, 1);
		M.onLeftUp.add(leftUp,1);
		M.onMiddleUp.add(rightUp, 1);
		M.onRightUp.add(middleUp, 1);
	}
	
	public static function disableStd():Void {
		M.onMove.remove(moveEvent.dispatch);
		M.onLeftDown.remove(leftDown);
		M.onMiddleDown.remove(rightDown);
		M.onRightDown.remove(middleDown);
		M.onLeftUp.remove(leftUp);
		M.onMiddleUp.remove(rightUp);
		M.onRightUp.remove(middleUp);
	}
	
	private static function leftDown(x:Float, y:Float):Void downEvent.dispatch(x, y, MouseButton.LEFT);
	private static function rightDown(x:Float, y:Float):Void downEvent.dispatch(x, y, MouseButton.RIGHT);
	private static function middleDown(x:Float, y:Float):Void downEvent.dispatch(x, y, MouseButton.MIDDLE);
	private static function leftUp(x:Float, y:Float):Void upEvent.dispatch(x, y, MouseButton.LEFT);
	private static function rightUp(x:Float, y:Float):Void upEvent.dispatch(x, y, MouseButton.RIGHT);
	private static function middleUp(x:Float, y:Float):Void upEvent.dispatch(x, y, MouseButton.MIDDLE);
	
}
