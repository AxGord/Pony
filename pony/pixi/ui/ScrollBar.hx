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

import pixi.core.display.DisplayObject.DestroyOptions;
import pixi.core.sprites.Sprite;
import pony.events.Signal0;
import pony.geom.Point;
import pony.pixi.ui.Bar;
import pony.ui.touch.pixi.Touchable;
import pony.ui.touch.Touch;

/**
 * ScrollBar
 * @author AxGord <axgord@gmail.com>
 */
class ScrollBar extends Sprite {
	
	public var onReady:Signal0;
	private var bar:Bar;
	private var totalSize:Float;
	public var pos(default, set):Int = 0;
	private var contentSize:Float;
	private var touchable:Touchable;
	private var startTPos:Float;
	private var startTPosBefore:Int;
	private var vert:Bool;
	
	public function new(
		size:Int,
		begin:String,
		body:String,
		vert:Bool = true,
		?offset:Point<Int>,
		useSpriteSheet:Bool = false,
		creep:Float = 0
	) {
		super();
		this.vert = vert;
		totalSize = size;
		var point = vert ? new Point(0, size) : new Point(size, 0);
		bar = new Bar(point, begin, body, offset, false, useSpriteSheet, creep);
		addChild(bar);
		onReady = bar.onReady;
	}
	
	public function updateContent(size:Float):Void {
		contentSize = size;
		bar.core.percent = size > totalSize ? totalSize / size : 1;
		if (pos < totalSize - contentSize) pos = Std.int(totalSize - contentSize);
		updatePos();
	}
	
	public dynamic function onChangePosition(v:Int):Void {}
	
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
	
	@:extern inline private function updatePos():Void {
		onChangePosition(pos);
		var p = ( pos / (totalSize - contentSize));
		var v = (totalSize - bar.core.pos) * p;
		if (vert)
			bar.y = v;
		else
			bar.x = v;
	}
	
	public function setTouchable(t:Touchable):Void {
		touchable = t;
		touchable.onDown < beginMove;
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
		if (onReady == null) return;
		move(t);
		touchable.onDown < beginMove;
	}
	
	private function move(t:Touch):Void pos = startTPosBefore - Std.int(startTPos - (vert ? t.y : t.x));
	
	override public function destroy(?options:haxe.extern.EitherType<Bool, DestroyOptions>):Void {
		onChangePosition = null;
		removeChild(bar);
		bar.destroy();
		bar = null;
		onReady = null;
		touchable = null;
		super.destroy(options);
	}
	
}