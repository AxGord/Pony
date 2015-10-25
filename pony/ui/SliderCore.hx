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
package pony.ui;

import pony.events.Event0;
import pony.events.Event1;
import pony.events.Signal1;
import pony.magic.Declarator;
import pony.magic.HasSignal;
import pony.touch.Touch;

/**
 * SliderCore
 * @author AxGord <axgord@gmail.com>
 */
class SliderCore implements Declarator implements HasSignal {
	
	@:arg private var b:ButtonCore = null;
	@:arg public var size(default,null):Float;
	@:arg public var isVertical(default,null):Bool = false;
	
	@:bindable public var percent:Float = 0;
	@:bindable public var pos:Float = 0;
	@:bindable public var value:Float = 0;
	@:bindable public var finalPercent:Float = 0;
	@:bindable public var finalPos:Float = 0;
	@:bindable public var finalValue:Float = 0;
	
	public var onStartDrag(default, null):Signal1<Touch>;
	public var onStopDrag(default, null):Signal1<Touch>;
	
	private var d:Float = 0;
	
	public function new() {
		changePercent << changePercentHandler;
		changePos << changePosHandler;
		if (b != null) {
			onStartDrag = b.touch.onDown;
			onStopDrag = b.touch.onUp || b.touch.onOutUp;
		} else {
			onStartDrag = new Event1();
			onStopDrag = new Event1();
		}
		onStopDrag << stopDragHandler;
		if (isVertical) {
			onStartDrag << startYDragHandler;
			changePos << function(v) changeY(v);//Coz changeY dynamic function
		} else {
			onStartDrag << startXDragHandler;
			changePos << function(v) changeX(v);//Coz changeX dynamic function
		}
		onStartDrag << startDragHandler;
		changePos << b.touch.check;
	}
	
	@:extern inline
	public static function create(?b:ButtonCore, width:Float, height:Float):SliderCore {
		var isVert = height > width;
		return new SliderCore(b, isVert ? height : width, isVert);
	}
	
	private function changePercentHandler(v:Float):Void pos = v * size;
	private function changePosHandler(v:Float):Void percent = v / size;
	
	private function stopDragHandler(t:Touch):Void {
		if (t != null) t.onMove >> moveHandler;
		finalPos = pos;
		finalPercent = percent;
		finalValue = value;
		changePos << b.touch.check;
	}
	
	inline public function startDrag():Void untyped (onStartDrag:Event0).dispatch();
	inline public function stopDrag():Void untyped (onStopDrag:Event0).dispatch();
	
	/**
	 * Set view to default position
	 */
	inline public function endInit():Void {
		if (isVertical) {
			changeY(0);
		} else {
			changeX(0);
		}
	}
	
	private function startXDragHandler(t:Touch):Void d = pos - t.x;
	private function startYDragHandler(t:Touch):Void d = pos - t.y;
	
	private function startDragHandler(t:Touch):Void {
		t.onMove << moveHandler;
		changePos >> b.touch.check;
	}
	
	private function moveHandler(t:Touch):Void {
		var p = (isVertical ? t.y : t.x) + d;
		if (p < 0) pos = 0;
		else if (p > size) pos = size;
		else pos = p;
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
		max -= min;
		changePercent << function(v:Float) value = min + v * max;
	}
	
}