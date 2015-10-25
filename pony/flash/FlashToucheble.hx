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
package pony.flash;

import flash.display.DisplayObject;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.Lib;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import pony.events.Event0;
import pony.events.Event1;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.time.DeltaTime;
import pony.touch.TouchebleBase;

/**
 * FlashToucheble
 * @author AxGord <axgord@gmail.com>
 */
class FlashToucheble extends TouchebleBase {

	static public var touchMode(default,null):Bool = false;
	static private var globalUp:Event1<Int>;
	static private var globalOut:Event0;
	static private var lockOver:Int = -1;
	static private var idCounter:Int = 0;
	static public var down(default, null):Bool = false;
	
	private var over:Bool = false;
	private var id:Int;
	private var obj:DisplayObject;
	
	@:extern inline private static function init():Void {
		if (globalUp != null) return;
		globalUp = new Event1();
		globalOut = new Event0();
		if (Multitouch.supportsTouchEvents) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, switchToMouse, true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, switchToTouch, true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, switchToTouch, true);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, switchToTouch, true);
			
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, touchGlobalEndHandler);
			
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, globalTouchMoveHandler, true);
		}
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_UP, globalUpHandler);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, globalDownHandler);
		Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, globalMoveHandler);
	}
	
	private static function switchToMouse(_):Void {
		touchMode = false;
	}
		
	private static function switchToTouch(_):Void {
		touchMode = true;
	}
	
	public function new(obj:DisplayObject) {
		super();
		this.obj = obj;
		id = idCounter++;
		init();
		if (Multitouch.supportsTouchEvents) {
			obj.addEventListener(TouchEvent.TOUCH_BEGIN, touchBeginHandler);
			obj.addEventListener(TouchEvent.TOUCH_END, touchEndHandler);
			obj.addEventListener(TouchEvent.TOUCH_MOVE, touchMoveHandler);
			Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, touchGlobalMoveHandler);
		}
		obj.addEventListener(MouseEvent.MOUSE_OVER, overHandler);
		obj.addEventListener(MouseEvent.MOUSE_OUT, outHandler);
		obj.addEventListener(MouseEvent.MOUSE_DOWN, downHandler);
		obj.addEventListener(MouseEvent.MOUSE_UP, upHandler);
		
		obj.addEventListener(MouseEvent.RELEASE_OUTSIDE, globalOutsideHandler);
		
		(globalOut:Signal0) << makeOut;
		(globalUp:Signal1<Int>) << dispatchOutUpListener;
		onDown << function() onUp < eClick;
		onOutUp << function() onUp >> eClick;
	}
	
	@:extern inline private function isLock():Bool return lockOver != -1 && lockOver != id;
	
	private function overHandler(_):Void {
		if (touchMode) return;
		makeOver();
	}
	
	private function outHandler(_):Void {
		if (touchMode) return;
		makeOut();
	}
	
	static private function globalMoveHandler(e:MouseEvent):Void {
		if (touchMode) return;
		TouchebleBase.dispatchMove(0, e.stageX, e.stageY);
	}
	
	static private function globalTouchMoveHandler(e:TouchEvent):Void {
		if (!touchMode) return;
		TouchebleBase.dispatchMove(e.touchPointID, e.stageX, e.stageY);
	}
	
	private function downHandler(e:MouseEvent):Void {
		if (touchMode) return;
		down = true;
		lockOver = id;
		dispatchDown(0, e.stageX, e.stageY);
	}
	
	private function upHandler(event:MouseEvent):Void {
		if (touchMode) return;
		if (!down) return;
		down = false;
		lockOver = -1;
		event.stopPropagation();
		if (over) dispatchUp();
		else DeltaTime.fixedUpdate < check;//Need check this after outside handle
	}
	
	private static function globalUpHandler(_):Void {
		if (touchMode) return;
		down = false;
		lockOver = -1;
		globalUp.dispatch(0);
	}
	
	private static function globalDownHandler(_):Void {
		if (touchMode) return;
		down = true;
	}
	
	private function globalOutsideHandler(_):Void {
		globalUpHandler(null);
	}
	
	private function touchBeginHandler(e:TouchEvent):Void {
		if (!touchMode) return;
		if (isLock()) return;
		lockOver = id;
		over = true;
		dispatchOver(e.touchPointID);
		dispatchDown(e.touchPointID, e.stageX, e.stageY);
	}
	
	private function touchEndHandler(e:TouchEvent):Void {
		if (!touchMode) return;
		e.stopPropagation();
		if (over) {
			dispatchUp(e.touchPointID);
			dispatchOut(e.touchPointID);
			over = false;
		} else {
			(globalUp:Signal1<Int>) >> dispatchOutUpListener;
			globalUp.dispatch(e.touchPointID);
			(globalUp:Signal1<Int>) << dispatchOutUpListener;
		}
		lockOver = -1;
	}
	
	private function touchMoveHandler(e:TouchEvent):Void {
		if (!touchMode) return;
		if (isLock()) return;
		e.stopPropagation();
		if (over) return;
		over = true;
		dispatchOverDown(e.touchPointID);
	}
	
	private function touchGlobalMoveHandler(e:TouchEvent):Void {
		if (!touchMode) return;
		if (isLock()) return;
		if (!over) return;
		over = false;
		dispatchOutDown(e.touchPointID);
	}
	
	private static function touchGlobalEndHandler(e:TouchEvent):Void {
		if (!touchMode) return;
		lockOver = -1;
		globalUp.dispatch(e.touchPointID);
	}

	override public function check():Void {
		if (touchMode) return;
		if (obj.hitTestPoint(obj.stage.mouseX, obj.stage.mouseY, true)) {
			makeOver();
			if (!down) {
				dispatchUp(0, true);
			}
		} else {
			makeOut();
			if (!down) {
				dispatchOutUp(0, true);
			}
		}
	}
	
	private function makeOver():Void {
		if (over || isLock()) return;
		over = true;
		down ? dispatchOverDown() : dispatchOver();
	}
	
	private function makeOut():Void {
		if (!over) return;
		over = false;
		down ? dispatchOutDown() : dispatchOut();
	}
	
}