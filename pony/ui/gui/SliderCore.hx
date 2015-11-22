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
package pony.ui.gui;

import pony.events.Event0;
import pony.events.Event1;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.ui.touch.Touch;

/**
 * SliderCore
 * @author AxGord <axgord@gmail.com>
 */
class SliderCore implements Declarator implements HasSignal {
	
	@:arg private var button:ButtonCore = null;
	@:arg public var size(default,null):Float;
	@:arg public var isVertical(default,null):Bool = false;
	@:arg public var invert:Bool = false;
	
	public var min(default, null):Float;
	public var max(default, null):Float;
	
	@:bindable public var percent:Float = 0;
	@:bindable public var pos:Float = 0;
	@:bindable public var value:Float = 0;
	@:bindable public var finalPercent:Float = 0;
	@:bindable public var finalPos:Float = 0;
	@:bindable public var finalValue:Float = 0;
	
	public var onStartDrag(default, null):Signal1<Touch>;
	public var onStopDrag(default, null):Signal1<Touch>;
	
	private var startPoint:Float = 0;
	
	public function new() {
		changePercent << changePercentHandler;
		changePos << changePosHandler;
		if (button != null) {
			onStartDrag = button.touch.onDown;
			onStopDrag = button.touch.onUp || button.touch.onOutUp;
		} else {
			onStartDrag = new Event1();
			onStopDrag = new Event1();
		}
		onStopDrag << stopDragHandler;
		if (isVertical) {
			onStartDrag << startYDragHandler;
			changePos << function(v) changeY(inv(v));
		} else {
			onStartDrag << startXDragHandler;
			changePos << function(v) changeX(inv(v));
		}
		onStartDrag << startDragHandler;
		if (button != null) changePos << button.touch.check;
	}
	
	@:extern inline
	public static function create(?b:ButtonCore, width:Float, height:Float, invert:Bool=false):SliderCore {
		var isVert = height > width;
		return new SliderCore(b, isVert ? height : width, isVert, invert);
	}
	
	public function destroy():Void {
		if (button != null) button.destroy();
	}
	
	private function changePercentHandler(v:Float):Void pos = v * size;
	private function changePosHandler(v:Float):Void percent = v / size;
	private function changeValueHandler(v:Float):Void percent = (max-min) / (v-min);
	
	private function stopDragHandler(t:Touch):Void {
		if (t != null) t.onMove >> moveHandler;
		finalPos = pos;
		finalPercent = percent;
		finalValue = value;
		if (button != null) changePos << button.touch.check;
	}
	
	inline public function startDrag(t:Touch):Void untyped (onStartDrag:Event1<Touch>).dispatch(t);
	inline public function stopDrag(t:Touch):Void untyped (onStopDrag:Event1<Touch>).dispatch(t);
	
	/**
	 * Set view to default position
	 */
	inline public function endInit():Void {
		if (isVertical) {
			changeY(inv(0));
		} else {
			changeX(inv(0));
		}
	}
	
	private function startXDragHandler(t:Touch):Void startPoint = inv(pos) - t.x;
	private function startYDragHandler(t:Touch):Void startPoint = inv(pos) - t.y;
	
	@:extern inline function inv(p:Float):Float return invert ? size - p : p;
	
	private function startDragHandler(t:Touch):Void {
		if (t != null) t.onMove << moveHandler;
		if (button != null) changePos >> button.touch.check;
	}
	
	private function moveHandler(t:Touch):Void {
		pos = limit(detectPos(t.x, t.y));
	}
	
	@:extern inline private function detectPos(x:Float, y:Float):Float {
		return inv((isVertical ? y : x) + startPoint);
	}
	
	@:extern inline private function limit(p:Float):Float {
		return if (p < 0) 0;
		else if (p > size) size;
		else p;
	}
	
	/**
	 * Use this method for connect view
	 */
	dynamic public function changeX(v:Float):Void { }
	
	/**
	 * Use this method for connect view
	 */
	dynamic public function changeY(v:Float):Void {}

	inline public function initValue(min:Float, max:Float):Void {
		this.min = min;
		this.max = max;
		changePercent << updateValue;
		changeValue << changeValueHandler;
	}
	
	private function updateValue(v:Float):Void {
		value = min + v * (max - min);
	}
	
}