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

import flash.events.TouchEvent;
import flash.Lib;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

typedef TO = {x:Float, y:Float, id:Int};

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Touch implements Declarator implements HasSignal {

	@:auto public static var onMove:Signal1<TO>;
	@:auto public static var onStart:Signal1<TO>;
	@:auto public static var onEnd:Signal1<TO>;
	
	private static var enabled:Bool = true;
	
	private static var tMove:Map<Int, TO> = new Map<Int, TO>();
	
	private static var startStack:Array<TO> = [];
	private static var endStack:Array<TO> = [];
	
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
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_MOVE, moveHandler, true, -1000);
	}
	
	@:extern inline private static function hackDown():Void {
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_BEGIN, startHandler, true, -1000);
	}
	
	@:extern inline private static function hackUp():Void {
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_END, endHandler, true, -1000);
	}
	
	public static function enableStd():Void {
		enabled = true;
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_OUT, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_OVER, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_ROLL_OUT, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_ROLL_OVER, lock, true);
		Lib.current.stage.removeEventListener(TouchEvent.TOUCH_TAP, lock, true);
	}
	
	public static function disableStd():Void {
		enabled = false;
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_OUT, lock, true, -1000);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_OVER, lock, true, -1000);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_ROLL_OUT, lock, true, -1000);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_ROLL_OVER, lock, true, -1000);
		Lib.current.stage.addEventListener(TouchEvent.TOUCH_TAP, lock, true, -1000);
	}
	
	private static function moveHandler(e:TouchEvent):Void {
		tMove[e.touchPointID] = {x:e.stageX, y:e.stageY, id:e.touchPointID};
		DeltaTime.fixedUpdate.once(moveDispatch, -8);
		tlock(e);
	}
	
	private static function moveDispatch():Void {
		for (t in tMove) eMove.dispatch(t);
		tMove = new Map();
	}
	
	private static function startHandler(e:TouchEvent):Void {
		startStack.push({x:e.stageX, y:e.stageY, id:e.touchPointID});
		DeltaTime.fixedUpdate.once(startDispatch, -9);
		tlock(e);
	}
	
	private static function startDispatch():Void {
		for (t in startStack) eStart.dispatch(t);
		startStack = [];
	}
	
	private static function endHandler(e:TouchEvent):Void {
		endStack.push({x:e.stageX, y:e.stageY, id:e.touchPointID});
		DeltaTime.fixedUpdate.once(endDispatch, -7);
		tlock(e);
	}
	
	private static function endDispatch():Void {
		for (t in endStack) eEnd.dispatch(t);
		endStack = [];
	}
	
	private static function lock(event:TouchEvent):Void event.stopImmediatePropagation();
	@:extern inline private static function tlock(event:TouchEvent):Void if (!enabled) event.stopImmediatePropagation();
	
}