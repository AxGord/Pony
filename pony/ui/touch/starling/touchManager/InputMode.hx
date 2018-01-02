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
package pony.ui.touch.starling.touchManager;
import flash.events.MouseEvent;
import flash.Lib;
import flash.ui.Multitouch;
import haxe.Timer;

/**
 * ...
 * @author Maletin
 */
class InputMode
{
	private static var _initialized:Bool = false;
	
	private static var _touchMode:Bool = false;
	private static var _activeTouchesCounter:Int = 0;
	
	private static var _ignoreMouseMoveUntil:Float = 0;
	private static var _ignoreMouseMoveTimeMills:Int = 200;
	
	public static function init():Void
	{
		if (_initialized) return;
		
		if (Multitouch.supportsTouchEvents)
		{
			Lib.current.stage.addEventListener(flash.events.TouchEvent.TOUCH_BEGIN, touchBegins);
			Lib.current.stage.addEventListener(flash.events.TouchEvent.TOUCH_END, touchEnds);
			
			#if !disableMouseInput
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseInput);
			Lib.current.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseInput);
			#end
		}
		
		_initialized = true;
	}
	
	public static function touchMode():Bool
	{
		checkInitialized();
		return _touchMode;
	}
	
	private static function touchBegins(_):Void
	{
		//if (!_touchMode) trace("TOUCH MODE");
		
		_activeTouchesCounter++;
		
		_touchMode = true;
	}
	
	private static function touchEnds(_):Void
	{
		_activeTouchesCounter--;
		if (_activeTouchesCounter == 0)
		{
			_ignoreMouseMoveUntil = Timer.stamp() * 1000 + _ignoreMouseMoveTimeMills;
		}
	}
	
	#if !disableMouseInput
	private static function mouseInput(_):Void
	{
		if ( (_activeTouchesCounter == 0) && (_touchMode) && (Timer.stamp() * 1000 >= _ignoreMouseMoveUntil))
		{
			//trace("MOUSE MODE");
			
			_touchMode = false;
		}
	}
	#end
	
	private static function checkInitialized():Void
	{
		if (!_initialized) throw "Call InputMode.init() before usage (before any user input)";
	}
	
}