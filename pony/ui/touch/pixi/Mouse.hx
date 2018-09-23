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
package pony.ui.touch.pixi;

import js.Browser;
import pixi.core.display.Container;
import pixi.interaction.InteractionEvent;
import pony.geom.Point;
import pony.ui.touch.Mouse as M;

/**
 * Mouse
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.Mouse)
class Mouse {

	private static var obj:Container;

	public static var inited(default, null):Bool = false;
	
	public static function reg(obj:Container):Void {
		if (Mouse.obj == null) {
			Mouse.obj = obj;
			if (inited) _init();
		}
	}
	
	public static function init() {
		if (inited) return;
		inited = true;
		if (obj != null) _init();
	}
	
	public static function _init() {
		regSub(obj);
		M.eWheel.onTake << Browser.document.addEventListener.bind("wheel", wheelHandler, false);
		M.eWheel.onLost << Browser.document.removeEventListener.bind("wheel", wheelHandler, false);
	}

	public static function regSub(obj:Container):Void {
		obj.interactive = true;
		obj.on('mousedown', downHandler);
		obj.on('mouseup', upHandler);
		M.eMove.onTake << function() obj.on('mousemove', moveHandler);
		M.eMove.onLost << function() obj.removeListener('mousemove', moveHandler);
		M.eLeave.onTake << function() obj.on('mouseupoutside', upoutsideHandler);
		M.eLeave.onLost << function() obj.removeListener('mouseupoutside', upoutsideHandler);
	}
	
	private static function wheelHandler(e:Dynamic):Void {
		if (e.wheelDelta == null)
			M.eWheel.dispatch(e.deltaY > 0 ? -120 : 120);
		else
			M.eWheel.dispatch(e.wheelDelta);
		e.returnValue = false;
		e.preventDefault();
	}
	
	private static function downHandler(e:InteractionEvent):Void {
		var p = correction(e.data.global.x, e.data.global.y);
		M.downHandler(p.x, p.y, untyped e.data.originalEvent.button);
	}
	
	private static function upHandler(e:InteractionEvent):Void {
		var p = correction(e.data.global.x, e.data.global.y);
		M.upHandler(p.x, p.y, untyped e.data.originalEvent.button);
	}
	
	private static function moveHandler(e:InteractionEvent):Void {
		var p = correction(e.data.global.x, e.data.global.y);
		M.moveHandler(p.x, p.y);
	}
	
	private static function upoutsideHandler(_):Void M.eLeave.dispatch();
	
	public static dynamic function correction(x:Float, y:Float):Point<Float> return new Point(x, y);
	
}