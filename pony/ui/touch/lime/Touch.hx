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
package pony.ui.touch.lime;

#if js
import js.Browser;
import js.html.TouchEvent;
#end
import lime.app.Event;
import lime.ui.Touch as T;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
class Touch implements Declarator implements HasSignal {

	@:auto public static var onMove:Signal1<T>;
	@:auto public static var onStart:Signal1<T>;
	@:auto public static var onEnd:Signal1<T>;
	@:auto public static var onCancle:Signal1<Int>;
	
	private static var tMove:Map<Int, T> = new Map<Int, T>();
	
	private static var startStack:Array<T> = [];
	private static var endStack:Array<T> = [];
	
	private static var moveEvent:Event<lime.ui.Touch->Void>;
	private static var startEvent:Event<lime.ui.Touch->Void>;
	private static var endEvent:Event<lime.ui.Touch->Void>;
	
	@:extern inline public static function init():Void {
		DeltaTime.fixedUpdate.once(initNow, -2);
	}
	
	public static function initNow():Void {
		#if js
		eCancle.onTake << Browser.document.addEventListener.bind("touchcancel", handleTouchEvent);
		eCancle.onLost << Browser.document.removeEventListener.bind("touchcancel", handleTouchEvent);
		#end
		hackMove();
		hackDown();
		hackUp();
	}
	
	private static function hackMove():Void {
		moveEvent = T.onMove;
		var moveEvent = new Event<lime.ui.Touch->Void>();
		moveEvent.add(moveHandler, false, 1000);
		T.onMove = moveEvent;
	}
	
	private static function hackDown():Void {
		startEvent = T.onStart;
		var event = new Event<lime.ui.Touch->Void>();
		event.add(startHandler, false, 1000);
		T.onStart = event;
	}
	
	private static function hackUp():Void {
		endEvent = T.onEnd;
		var event = new Event<lime.ui.Touch->Void>();
		event.add(endHandler, false, 1000);
		T.onEnd = event;
	}
	
	public static function enableStd():Void {
		onMove.add(moveEvent.dispatch,1);
		onStart.add(startEvent.dispatch,1);
		onEnd.add(endEvent.dispatch,1);
	}
	
	public static function disableStd():Void {
		onMove.remove(moveEvent.dispatch);
		startEvent.remove(startEvent.dispatch);
		endEvent.remove(endEvent.dispatch);
	}
	
	#if js
	private static function handleTouchEvent(event:TouchEvent):Void {
		for (t in event.changedTouches) eCancle.dispatch(t.identifier);
	}
	#end
	
	private static function moveHandler(t:T):Void {
		tMove[t.id] = t;
		DeltaTime.fixedUpdate.once(moveDispatch, -8);
	}
	
	private static function moveDispatch():Void {
		for (t in tMove) eMove.dispatch(t);
		tMove = new Map();
	}
	
	private static function startHandler(t:T):Void {
		startStack.push(t);
		DeltaTime.fixedUpdate.once(startDispatch, -9);
	}
	
	private static function startDispatch():Void {
		for (t in startStack) eStart.dispatch(t);
		startStack = [];
	}
	
	private static function endHandler(t:T):Void {
		endStack.push(t);
		DeltaTime.fixedUpdate.once(endDispatch, -7);
	}
	
	private static function endDispatch():Void {
		for (t in endStack) eEnd.dispatch(t);
		endStack = [];
	}
	
}