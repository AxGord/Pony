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
package pony.ui.gui;

import pony.magic.Declarator;
import pony.magic.HasSignal;

/**
 * BarCore
 * @author AxGord <axgord@gmail.com>
 */
class BarCore implements Declarator implements HasSignal {

	@:arg public var size(default,null):Float;
	@:arg public var isVertical(default,null):Bool = false;
	@:arg public var invert:Bool = false;
	
	@:bindable public var percent:Float = 0;
	@:bindable public var pos:Float = 0;
	@:bindable public var value:Float = 0;
	
	public var min(default, null):Float;
	public var max(default, null):Float;
	
	public function new() {
		changePercent << changePercentHandler;
		changePos << changePosHandler;
		if (isVertical) {
			changePos << function(v) changeY(inv(v));
		} else {
			changePos << function(v) changeX(inv(v));
		}
	}
	
	@:extern inline
	public static function create(width:Float, height:Float, invert:Bool=false):BarCore {
		var isVert = height > width;
		return new BarCore(isVert ? height : width, isVert, invert);
	}
	
	public function destroy():Void {
		destroySignals();
	}
	
	private function changePercentHandler(v:Float):Void pos = v * size;
	private function changePosHandler(v:Float):Void percent = v / size;
	private function changeValueHandler(v:Float):Void percent =  (v-min) / (max-min);
	private function updateValue(v:Float):Void value = min + v * (max - min);
	@:extern inline private function inv(p:Float):Float return invert ? size - p : p;
	
	/**
	 * Set view to default position
	 */
	public function endInit():Void {
		if (isVertical) {
			changeY(inv(0));
		} else {
			changeX(inv(0));
		}
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
	
	public function setPercent(v:Float):Void percent = v;
	
}