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
import flash.events.Event;
import flash.Lib;
import flash.ui.Mouse;
import flash.ui.MouseCursor;
import pony.ui.touch.starling.touchManager.TouchEventType;

/**
 * ...
 * @author Maletin
 */
class TouchManagerHandCursor
{
	private static var _hand:Bool = false;
	private static var _currentHand:Bool = false;
	private static var _initialized:Bool = false;
	
	private var _object:Dynamic;
	private var _hoveringOver:Bool = false;
	
	public var enabled(default, set):Bool = true;

	public function new(object:Dynamic) 
	{
		if (!_initialized) init();
		
		_object = object;
		
		TouchManager.addListener(_object, onTouch);
	}
	
	private function onTouch(e:TouchManagerEvent):Void
	{
		if (e.type == Hover) setHandCursor(Mouse.cursor == MouseCursor.BUTTON);
		setHandCursor( !(e.type == HoverOut || (e.type == Up && e.mouseOver == false)) );
	}
	
	private function setHandCursor(hand:Bool):Void
	{
		if (enabled) _hand = hand;
		_hoveringOver = hand;
	}
	
	public function set_enabled(value:Bool):Bool
	{
		enabled = value;
		if (_hoveringOver) _hand = enabled;
		return enabled;
	}
	
	private static function init():Void
	{
		_initialized = true;
		
		Lib.current.stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private static function onEnterFrame(e:Event):Void
	{
		if (_hand != _currentHand)
		{
			_currentHand = _hand;
			Mouse.cursor = _hand ? MouseCursor.BUTTON : MouseCursor.AUTO;
		}
	}
	
	public function dispose():Void
	{
		TouchManager.removeListener(_object, onTouch);
	}
	
}