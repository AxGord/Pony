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
import pony.ui.touch.pixi.Touch;

/**
 * TouchableTouch
 * @author AxGord <axgord@gmail.com>
 */
@:access(pony.ui.touch.TouchableBase)
class TouchableTouch {

	private static var inited:Bool = false;
	
	public static function init():Void {
		if (inited) return;
		inited = true;
		Touch.init();
		Touch.onMove << globalTouchMoveHandler;
	}
	
	static private function globalTouchMoveHandler(e:TouchObj):Void {
		TouchableBase.dispatchMove(e.id, e.x, e.y);
	}
	
	private var obj:Container;
	private var base:TouchableBase;
	private var touchId:Int = -1;
	private var over:Bool = false;
	private var down:Bool = false;
	
	public function new(obj:Container, base:TouchableBase) {
		init();
		this.obj = obj;
		this.base = base;
		obj.on('touchstart', touchBeginHandler);
		obj.on('touchmove', touchMoveHandler);
		obj.on('touchendoutside', outsideHandler);
		Touch.onEnd << touchEndHandler;
		Touch.onCancle << cancleTouchHandler;
	}
	
	public function destroy():Void {
		if (touchId != -1) lost(touchId);
		obj.removeListener('touchstart', touchBeginHandler);
		obj.removeListener('touchmove', touchMoveHandler);
		obj.removeListener('touchendoutside', outsideHandler);
		Touch.onEnd >> touchEndHandler;
		Touch.onCancle >> cancleTouchHandler;
		obj = null;
		base = null;
	}
	
	private function outsideHandler(e:EventTarget):Void {
		if (isLock(e.data.identifier)) return;
		over = false;
		base.dispatchOutDown(e.data.identifier);
	}
	
	private function isLock(t:Int):Bool {
		if (isNotLock(t)) {
			touchId = t;
			return false;
		} else
			return true;
	}
	
	@:extern inline private function unlock(t:Int):Void touchId = -1;
	@:extern inline private function isNotLock(t:Int):Bool return touchId == -1 || touchId == t;
	
	private function touchBeginHandler(e:EventTarget):Void {
		if (isLock(e.data.identifier)) return;
		over = true;
		down = true;
		base.dispatchOver(e.data.identifier);
		var p = Touch.correction(e.data.global.x, e.data.global.y);
		base.dispatchDown(e.data.identifier, p.x, p.y);
	}
	
	private function touchEndHandler(t:TouchObj):Void {
		if (!down) return;
		if (!isNotLock(t.id)) return;
		if (over) {
			base.dispatchUp(t.id);
			base.dispatchOut(t.id);
		} else {
			base.dispatchOutUp(t.id);
		}
		over = false;
		down = false;
		unlock(t.id);
	}
	
	private function touchMoveHandler(e:EventTarget):Void {
		if (!down) return;
		if (isLock(e.data.identifier)) return;
		if (over) return;
		over = true;
		base.dispatchOverDown(e.data.identifier);
	}
	
	private function cancleTouchHandler(id:Int):Void {
		if (!isNotLock(id)) return;
		lost(id);
	}
	
	private function lost(id:Int):Void {
		down = false;
		over = false;
		base.dispatchOutDown(id);
		base.dispatchOutUp(id);
		unlock(id);
	}
	
}