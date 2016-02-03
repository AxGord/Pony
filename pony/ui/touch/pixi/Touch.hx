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
package pony.ui.touch.pixi;

import pixi.core.display.Container;
import pixi.interaction.EventTarget;
import pony.events.Signal1;
import pony.geom.Point;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.time.DeltaTime;

typedef TouchObj = {x:Float, y:Float, id:Int};

/**
 * Touch
 * @author AxGord <axgord@gmail.com>
 */
class Touch implements Declarator implements HasSignal {
	
	@:auto public static var onMove:Signal1<TouchObj>;
	@:auto public static var onStart:Signal1<TouchObj>;
	@:auto public static var onEnd:Signal1<TouchObj>;
	@:auto public static var onCancle:Signal1<Int>;
	
	private static var tMove:Map<Int, TouchObj> = new Map<Int, TouchObj>();
	private static var startStack:Array<TouchObj> = [];
	private static var endStack:Array<TouchObj> = [];
	
	private static var obj:Container;
	private static var inited:Bool = false;
	
	public static function reg(obj:Container):Void {
		if (Touch.obj != null) throw 'ready';
		Touch.obj = obj;
		if (inited) _init();
	}
	
	public static function init() {
		if (inited) return;
		inited = true;
		if (obj != null) _init();
	}
	
	public static function _init() {
		obj.interactive = true;
		eMove.onTake << function() obj.on('touchstart', startHandler);
		eMove.onLost << function() obj.removeListener('touchstart', startHandler);
		eEnd.onTake << function() obj.on('touchend', endHandler);
		eEnd.onLost << function() obj.removeListener('touchend', endHandler);
		eMove.onTake << function() obj.on('touchmove', moveHandler);
		eMove.onLost << function() obj.removeListener('touchmove', moveHandler);
		eCancle.onTake << function() obj.on('touchendoutside', handleTouchEvent);
		eCancle.onLost << function() obj.removeListener('touchendoutside', handleTouchEvent);
		
	}
	
	private static function handleTouchEvent(e:EventTarget):Void {
		eCancle.dispatch(e.data.identifier);
	}
	
	@:extern inline private static function pack(e:EventTarget):TouchObj {
		var p = correction(e.data.global.x, e.data.global.y);
		return { id:e.data.identifier, x:p.x, y:p.y };
	}
	
	private static function moveHandler(e:EventTarget):Void {
		tMove[e.data.identifier] = pack(e);
		DeltaTime.fixedUpdate.once(moveDispatch, -8);
	}
	
	private static function moveDispatch():Void {
		for (t in tMove) eMove.dispatch(t);
		tMove = new Map();
	}
	
	private static function startHandler(e:EventTarget):Void {
		startStack.push(pack(e));
		DeltaTime.fixedUpdate.once(startDispatch, -9);
	}
	
	private static function startDispatch():Void {
		for (t in startStack) eStart.dispatch(t);
		startStack = [];
	}
	
	private static function endHandler(e:EventTarget):Void {
		endStack.push(pack(e));
		DeltaTime.fixedUpdate.once(endDispatch, -7);
	}
	
	private static function endDispatch():Void {
		for (t in endStack) eEnd.dispatch(t);
		endStack = [];
	}
	
	public static dynamic function correction(x:Float, y:Float):Point<Float> return new Point(x, y);
	
}