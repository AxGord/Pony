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
package pony.ui.touch.flash;

import flash.display.DisplayObject;
import flash.ui.Multitouch;
import flash.ui.MultitouchInputMode;
import pony.events.Signal1;
import pony.time.DeltaTime;
import pony.time.DTimer;
import pony.ui.touch.flash.Touch;
import pony.ui.touch.Mouse;
import pony.ui.touch.TouchebleBase;

/**
 * Toucheble
 * @author AxGord <axgord@gmail.com>
 */
class Toucheble extends TouchebleBase {
	
	@:bindable static public var touchMode:Bool = false;
	public static var onAnyTouch(default, null):Signal1<TO>;
	public static var touchSupport(get, null):Bool;
	
	private static var inited:Bool = false;
	private static var needSw:Bool = false;
	private static var wait:Bool = false;
	
	@:extern inline private static function get_touchSupport():Bool {
		#if touchsim
		return true;
		#else
		return Multitouch.supportsTouchEvents;
		#end
	}
	
	@:extern inline private static function init():Void {
		if (inited) return;
		inited = true;
		Mouse.init();
		if (touchSupport) {
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			Touch.init();
			DeltaTime.fixedUpdate < Touch.enableStd;
			onAnyTouch = Touch.onEnd || Touch.onStart || Touch.onMove;
			firstSwitchToTouch();
			DeltaTime.fixedUpdate < Touch.enableStd;
		} else {
			DeltaTime.fixedUpdate < Mouse.enableStd;
		}
	}
	
	private static function switchToMouse():Void {
		needSw = false;
		Touch.disableStd();
		onAnyTouch >> touchHandler;
		Mouse.onMove >> mouseHandler;
		onAnyTouch << switchToTouch;
		touchMode = false;
		Mouse.enableStd();
	}
	
	private static function switchToTouch():Void {
		needSw = false;
		Mouse.disableStd();
		Touch.enableStd();
		firstSwitchToTouch();
		onAnyTouch >> switchToTouch;
	}
	
	private static function firstSwitchToTouch():Void {
		touchMode = true;
		onAnyTouch << touchHandler;
		Mouse.onMove << mouseHandler;
	}
	
	private static function mouseHandler():Void {
		if (wait) return;
		wait = true;
		needSw = true;
		DTimer.fixedDelay(500, needSwToMouse);
	}
	
	private static function needSwToMouse():Void {
		wait = false;
		if (needSw) switchToMouse();
		needSw = false;
	}
		
	private static function touchHandler():Void {
		needSw = false;
	}
	
	private var obj:DisplayObject;
	private var touch:TouchebleTouch;
	private var mouse:TouchebleMouse;
	
	public function new(obj:DisplayObject) {
		super();
		this.obj = obj;
		init();
		if (touchMode)
			touch = new TouchebleTouch(obj, this);
		else
			mouse = new TouchebleMouse(obj, this);
		changeTouchMode - true << toTouch;
		changeTouchMode - false << toMouse;
	}
	
	override public function destroy():Void {
		changeTouchMode - true >> toTouch;
		changeTouchMode - false >> toMouse;
		obj = null;
		if (touchMode) {
			touch.destroy();
			touch = null;
		} else {
			mouse.destroy();
			mouse = null;
		}
		super.destroy();
	}
	
	private function toTouch():Void {
		mouse.destroy();
		mouse = null;
		touch = new TouchebleTouch(obj, this);
	}
	
	private function toMouse():Void {
		touch.destroy();
		touch = null;
		mouse = new TouchebleMouse(obj, this);
	}
	
}