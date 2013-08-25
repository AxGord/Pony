/**
* Copyright (c) 2012-2013 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony;
import pony.events.Signal;

/**
 * ...
 * @author AxGord
 */
class DeltaTime {
	
	public static var speed:Float = 1;
	public static var update(default,null):Signal;
	//public static var value(default,null):Float = 0;
	
	private static var t:Float;
	
	#if !flash
	public static inline function init(?signal:Signal):Void {
		set();
		if (signal != null) signal.add(tick);
	}
	#end
	
	private static function tick():Void {
		var value:Float = get();
		set();
		update.dispatch(value);
	}
	
	private inline static function set():Void t = Date.now().getTime();
	private inline static function get():Float return (Date.now().getTime() - t) * speed / 1000;

	
	#if (flash && !munit)
	public static function __init__():Void {
		update = new Signal();
		update.takeListeners.add(_takeListeners);
		update.lostListeners.add(_lostListeners);
	}
	public static function _tick(_):Void tick();
	public static function _takeListeners():Void {
		_set();
		flash.Lib.current.addEventListener(flash.events.Event.ENTER_FRAME, _tick);
	}
	public static function _lostListeners():Void flash.Lib.current.removeEventListener(flash.events.Event.ENTER_FRAME, _tick);
	public static inline function _set():Void set();
	#end
	
	#if (!flash || munit)
	public static function __init__():Void {
		update = new Signal();
	}
	#end
	
}