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
package pony.pixi.ui;

import pixi.core.display.Container;
import pony.ui.touch.Touch;
import pony.ui.touch.pixi.Touchable;

/**
 * Scrollable
 * @author AxGord <axgord@gmail.com>
 */
class Scrollable extends Touchable {
	
	public var pos(default, set):Int = 0;
	private var totalSize:Float;
	private var contentSize:Float;
	private var startTPos:Float;
	private var startTPosBefore:Int;
	private var vert:Bool;
	private var inited:Bool = false;

	public function new(obj:Container, totalSize:Float, vert:Bool) {
		super(obj);
		this.totalSize = totalSize;
		this.vert = vert;
	}
	
	public function updateContent(obj:Container):Void {
		if (vert)
			_updateContent(obj.height);
		else
			_updateContent(obj.width);
	}
	
	public function _updateContent(size:Float):Void {
		if (!inited) {
			inited = true;
			onDown < beginMove;
			onWheel << mouseWheelHandler;
		}
		contentSize = size;
		if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
		updatePos();
	}
	
	public dynamic function onChangePosition(v:Int):Void {}
	
	private function mouseWheelHandler(delta:Int):Void scroll(Std.int(delta / 2));
	
	public function scroll(delta:Int):Void pos += delta;
	
	@:extern inline private function set_pos(v:Int):Int {
		if (v != pos) {
			pos = v;
			if (pos > 0) pos = 0;
			if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
			updatePos();
		}
		return pos;
	}
	
	public function scrollToEnd():Void {
		pos = Std.int(totalSize - contentSize);
		updatePos();
	}
	
	@:extern inline private function updatePos():Void {
		if (vert)
			obj.y = pos;
		else
			obj.x = pos;
		onChangePosition(pos);
	}
	
	private function beginMove(t:Touch):Void {
		startTPosBefore = pos;
		startTPos = vert ? t.y : t.x;
		t.onMove << move;
		t.onUp < endMove;
		t.onOutUp < endMove;
	}
	
	private function endMove(t:Touch):Void {
		t.onUp >> endMove;
		t.onOutUp >> endMove;
		t.onMove >> move;
		move(t);
		onDown < beginMove;
	}
	
	private function move(t:Touch):Void pos = startTPosBefore - Std.int(startTPos - (vert ? t.y : t.x));
	
}