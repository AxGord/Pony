/**
* Copyright (c) 2012-2016 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.ui.touch;

import pony.events.Signal0;
import pony.events.Signal2;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.Tools.ArrayTools;

private typedef MouseEvent = {x:Float, y:Float, b:MouseButton};

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Mouse implements Declarator implements HasSignal {

	@:auto public static var onMove:Signal2<Float, Float>;
	@:auto public static var onLeftDown:Signal2<Float, Float>;
	@:auto public static var onLeftUp:Signal2<Float, Float>;
	@:auto public static var onRightDown:Signal2<Float, Float>;
	@:auto public static var onRightUp:Signal2<Float, Float>;
	@:auto public static var onMiddleDown:Signal2<Float, Float>;
	@:auto public static var onMiddleUp:Signal2<Float, Float>;
	@:auto public static var onLeave:Signal0;
	
	public static var x(default, null):Float;
	public static var y(default, null):Float;
	public static var actualX(default, null):Float;
	public static var actualy(default, null):Float;
	
	private static var downStack:Array<MouseEvent> = [];
	private static var upStack:Array<Int> = [];
	
	#if pixijs
	inline public static function init():Void pony.ui.touch.pixijs.Mouse.init();
	#elseif flash
	inline public static function init():Void pony.ui.touch.flash.Mouse.init();
	inline public static function enableStd():Void pony.ui.touch.flash.Mouse.enableStd();
	inline public static function disableStd():Void pony.ui.touch.flash.Mouse.disableStd();
	#elseif lime
	inline public static function init():Void pony.ui.touch.lime.Mouse.init();
	inline public static function enableStd():Void pony.ui.touch.lime.Mouse.enableStd();
	inline public static function disableStd():Void pony.ui.touch.lime.Mouse.disableStd();
	#end
	
	public static function moveHandler(x:Float, y:Float):Void {
		Mouse.x = x;
		Mouse.y = y;
		DeltaTime.fixedUpdate.once(moveDispatch, -4);
	}
	
	private static function moveDispatch():Void {
		eMove.dispatch(x, y);
	}
	
	public static function downHandler(x:Float, y:Float, b:Int):Void {
		downStack.push({x:x,y:y,b:b});
		DeltaTime.fixedUpdate.once(downDispatch, -5);
	}
	
	private static function downDispatch():Void {
		for (e in downStack) {
			switch e.b {
				case MouseButton.LEFT: eLeftDown.dispatch(e.x, e.y);
				case MouseButton.MIDDLE: eMiddleDown.dispatch(e.x, e.y);
				case MouseButton.RIGHT: eRightDown.dispatch(e.x, e.y);
			}
		}
		downStack = [];
	}
	
	public static function checkUp(b:Int):Bool {
		if (upStack.length > 0) {
			var l = ArrayTools.last(upStack);
			if (l == b) return false;
		}
		return true;
	}
	
	public static function checkDown(b:Int):Bool {
		if (upStack.length > 0) {
			var l = ArrayTools.last(downStack);
			if (l == null || l.b == b) return false;
		}
		return true;
	}
	
	public static function upHandler(x:Float, y:Float, b:Int):Void {	
		upStack.push(b);
		DeltaTime.fixedUpdate.once(upDispatch, -3);
	}
	
	private static function upDispatch():Void {
		for (e in upStack) switch e {
			case MouseButton.LEFT: eLeftUp.dispatch(x, y);
			case MouseButton.MIDDLE: eMiddleUp.dispatch(x, y);
			case MouseButton.RIGHT: eRightUp.dispatch(x, y);
		}
		upStack = [];
	}
	
}