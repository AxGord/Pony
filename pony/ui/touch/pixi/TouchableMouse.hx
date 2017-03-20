/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import pixi.interaction.InteractionEvent;
import pony.ui.touch.Mouse;

/**
 * TouchableMouse
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.TouchableBase)
class TouchableMouse {

	private static var inited:Bool = false;
	static public var down(default, null):Bool = false;
	
	public static function init():Void {
		if (inited) return;
		inited = true;
		pony.ui.touch.pixi.Mouse.init();
		Mouse.onMove << TouchableBase.dispatchMove.bind(0);
		Mouse.onLeftDown << function() down = true;
		Mouse.onLeftUp << function() down = false;
		Mouse.onLeave << function() down = false;
	}
	
	private var obj:Container;
	private var base:TouchableBase;
	private var over:Bool = false;
	private var _down:Bool = false;
	
	public function new(obj:Container, base:TouchableBase) {
		init();
		this.obj = obj;
		this.base = base;
		obj.on('mouseover', overHandler);
		obj.on('mouseout', outHandler);
		obj.on('mousedown', downHandler);
		obj.on('mouseup', upHandler);
		Mouse.onLeftUp << globUpHandler;
		Mouse.onLeave << leaveHandler;
	}
	
	public function destroy() {
		leaveHandler();
		obj.removeListener('mouseover', overHandler);
		obj.removeListener('mouseout', outHandler);
		obj.removeListener('mousedown', downHandler);
		obj.removeListener('mouseup', upHandler);
		Mouse.onLeftUp >> globUpHandler;
		Mouse.onLeave >> leaveHandler;
		obj = null;
		base = null;
	}
	
	private function overHandler(_):Void {
		over = true;
		down ? base.dispatchOverDown() : base.dispatchOver();
	}
	
	private function outHandler(_):Void {
		over = false;
		down ? base.dispatchOutDown() : base.dispatchOut();
	}
	
	private function downHandler(e:InteractionEvent):Void {
		if (untyped e.data.originalEvent.button != MouseButton.LEFT) return;
		if (!over) {
			over = true;
			base.dispatchOver();
		}
		_down = true;
		var p = pony.ui.touch.pixi.Mouse.correction(e.data.global.x, e.data.global.y);
		base.dispatchDown(0, p.x, p.y);
	}
	
	private function upHandler(e:InteractionEvent):Void {
		if (untyped e.data.originalEvent.button != MouseButton.LEFT) return;
		_down = false;
		if (!over) return;
		base.dispatchUp();
	}
	
	private function globUpHandler():Void {
		_down = false;
		if (!over) base.dispatchOutUp();
		else base.dispatchUp();
	}
	
	private function leaveHandler():Void {
		if (over) {
			over = false;
			_down ? base.dispatchOutDown() : base.dispatchOut();
		}
		if (_down) {
			_down = false;
			base.dispatchOutUp();
		}
	}
	
}