/**
* Copyright (c) 2012 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.events.MouseEvent;
import pony.events.Signal;
import pony.ui.ButtonCore;
import pony.ui.SlideCore;

using pony.flash.FLExtends;
/**
 * ...
 * @author AxGord
 */
class ScrollBar extends Sprite {

	public var scroller:Button;
	public var bg:DisplayObject;
	public var size(get, set):Float;
	public var total(default, set):Float;
	public var position(get,set):Float;
	public var isVert:Bool;
	public var update:Signal;
	
	private var rect:Rectangle;
	private var mouseMove:Signal;
	private var scrollerSize(get, null):Float;
	private var scrollerPos(get, null):Float;
	
	private var slideCore:SlideCore;
	
	private var _position:Float;
	
	public function new() {
		slideCore = new SlideCore(1, 20);
		slideCore.update.add(slUpdate);
		update = new Signal();
		_position = 0;
		isVert = width < height;
		super();
		addEventListener(Event.ENTER_FRAME, init);
	}
	
	private function init(Void):Void {
		removeEventListener(Event.ENTER_FRAME, init);
		mouseMove = stage.buildSignal(MouseEvent.MOUSE_MOVE);
		mouseMove.silent = true;
		mouseMove.add(scrollerMove);
		rect = isVert ? new Rectangle(0, 0, bg.height-scroller.height, 0) : new Rectangle(0, 0, bg.width-scroller.width, 0);
		scroller.core.down.add(scroller.startDrag.bind(false, rect)).add(mouseMove.disableSilent);
		scroller.core.change.sub([ButtonStates.Default]).add(scroller.stopDrag).add(mouseMove.enableSilent);
	}
	
	private function get_size():Float {
		return isVert ? bg.height : bg.width;
	}
	
	private function set_size(v:Float):Float {
		var ss:Float = size - scrollerSize;
		if (isVert) {
			bg.height = v;
			updateScroller();
			if (rect != null)
				rect.height = v - scroller.height;
			var ns:Float = size - scrollerSize;
			scroller.y *= ns / ss;
		} else {
			bg.width = v;
			updateScroller();
			if (rect != null)
				rect.width = v - scroller.width;
			var ns:Float = size - scrollerSize;
			scroller.x *= ns / ss;
		}
		scrollerMove();
		
		return v;
	}
	
	private function set_total(v:Float):Float {
		total = v;
		updateScroller();
		return v;
	}
	
	private function updateScroller():Void {
		if (isVert) {
			scroller.y = position;
			scroller.height = size * size / total;
		} else {
			scroller.x = position;
			scroller.width = size * size / total;
		}
		if (scrollerSize >= size - 10)
			slideCore.close();
		else
			slideCore.open();
	}
	
	private function scrollerMove():Void {
		_position = scrollerPos;
		update.dispatch(position);
	}
	
	private inline function get_scrollerSize():Float return isVert ? scroller.height : scroller.width;
	private inline function get_scrollerPos():Float return isVert ? scroller.y : scroller.x;
	
	private inline function get_position():Float return _position;

	public function set_position(p:Float):Float {
		if (p < 0) p = 0;
		else if (p > size - scrollerSize) p = size - scrollerSize;
		_position = p;
		updateScroller();
		update.dispatch(position);
		return position;
	}
	
	private function slUpdate(v:Float):Void alpha = v;
}