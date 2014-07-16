/**
* Copyright (c) 2013-2014 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.flash.ui;
import flash.events.MouseEvent;
import flash.events.TouchEvent;
import flash.display.MovieClip;
import flash.ui.Multitouch;
import pony.geom.Point;
import pony.ui.ButtonCore;

/**
 * TurningFree
 * @author AxGord <axgord@gmail.com>
 */
class TurningFree extends Turning {
	
	@:st public var button:Button;
	@:st public var lmin:MovieClip;
	@:st public var lmax:MovieClip;
	
	public function new() {
		super();
		FLTools.init < init;
	}
	
	private function init():Void {
		if (lmin != null) core.minAngle = lmin.rotation;
		if (lmax != null) core.maxAngle = lmax.rotation;
		core.currentAngle = handle.rotation;
		handle.mouseEnabled = false;
		button.core.down.add(beginMove);
		button.core.change.sub(ButtonStates.Default).add(endMove);
		button.core.change.sub(ButtonStates.Focus).add(endMove);
	}
	
	inline private function toMouse():Void core.toPoint({x:mouseX, y:mouseY});
	
	private function beginMove():Void {
		toMouse();
		if (Multitouch.supportsTouchEvents)
			stage.addEventListener(TouchEvent.TOUCH_MOVE, touchMove);
		else
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
	}
	
	private function endMove():Void {
		stage.removeEventListener(TouchEvent.TOUCH_MOVE, touchMove);
		stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
	}
	
	private function touchMove(e:TouchEvent):Void core.toPoint({x: e.stageX-x, y: e.stageY-y});
	private function mouseMove(_:MouseEvent):Void toMouse();
	
}