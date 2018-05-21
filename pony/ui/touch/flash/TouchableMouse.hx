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
package pony.ui.touch.flash;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.Lib;
import pony.time.DeltaTime;
import pony.ui.touch.Mouse;
import pony.ui.touch.TouchableBase;

/**
 * TouchebleMouse
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.TouchableBase)
class TouchableMouse {

	private static var inited:Bool = false;
	static public var down(default, null):Bool = false;
	
	public static function init():Void {
		if (inited) return;
		inited = true;
		Mouse.onMove << TouchableBase.dispatchMove.bind(0);
		
		Mouse.onLeftDown << function() down = true;
		Mouse.onLeftUp << function() down = false;
		Mouse.onLeave << function() down = false;
	}
	
	private var obj:DisplayObject;
	private var base:TouchableBase;
	private var over:Bool = false;
	private var _down:Bool = false;
	private var overBeforeCheck:Bool;
	
	public function new(obj:DisplayObject, base:TouchableBase) {
		init();
		this.obj = obj;
		this.base = base;
		obj.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
		obj.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		
		obj.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		obj.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, globUpHandler, false);

		obj.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		
		Mouse.onLeave << leaveHandler;
	}
	
	public function destroy() {
		leaveHandler();
		obj.removeEventListener(MouseEvent.MOUSE_OVER, overHandler);
		obj.removeEventListener(MouseEvent.MOUSE_OUT, outHandler);
		obj.removeEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		obj.removeEventListener(MouseEvent.MOUSE_UP, upHandler);
		Lib.current.stage.removeEventListener(MouseEvent.MOUSE_UP, globUpHandler, false);
		obj.removeEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		Mouse.onLeave >> leaveHandler;
		obj = null;
		base = null;
	}
	
	private function overHandler(_):Void {
		over = true;
		down ? base.dispatchOverDown() : base.dispatchOver();
	}
	
	private function outHandler(_):Void {
		over = false;
		down ? base.dispatchOutDown() : base.dispatchOut();
	}
	
	private function downHandler(e:MouseEvent):Void {
		_down = true;
		base.dispatchDown(0, e.stageX, e.stageY);
	}
	
	private function upHandler(_):Void {
		_down = false;
		if (!over) base.dispatchOutUp();
		else base.dispatchUp();
	}
	
	private function globUpHandler(_):Void {
		_down = false;
		if (!over) base.dispatchOutUp();
		else DeltaTime.fixedUpdate < up;
	}

	private function wheelHandler(e:MouseEvent):Void {
		base.eWheel.dispatch(e.delta);
	}
	
	private function up():Void {
		if (!over) base.dispatchOutUp();
		else base.dispatchUp();
	}
	
	private function leaveHandler():Void {
		if (over) {
			over = false;
			_down ? base.dispatchOutDown() : base.dispatchOut();
		}
		if (_down) {
			_down = false;
			base.dispatchOutUp();
		}
	}
	
}