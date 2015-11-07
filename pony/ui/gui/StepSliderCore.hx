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

import pony.math.MathTools;
import pony.ui.touch.Touch;

/**
 * StepSliderCore
 * @author AxGord <axgord@gmail.com>
 */
class StepSliderCore extends SliderCore {

	public var posStep:Float = 0;
	public var percentStep(get, set):Float;
	public var valueStep(get, set):Float;
	private var percentRound:Int = -1;
	private var valueRound:Int = -1;
	
	public function new(button:ButtonCore = null, size:Float, isVertical:Bool = false, invert:Bool = false) {
		super(button, size, isVertical, invert);
	}
	
	@:extern inline
	public static function create(?button:ButtonCore, width:Float, height:Float, invert:Bool=false):StepSliderCore {
		var isVert = height > width;
		return new StepSliderCore(button, isVert ? height : width, isVert, invert);
	}
	
	@:extern inline private function set_percentStep(v:Float):Float {
		posStep = size * v;
		percentRound = MathTools.lengthAfterComma(v);
		valueRound = -1;
		return v;
	}
	
	@:extern inline private function get_percentStep():Float return posStep == 0 ? 0 : posStep / size;
	
	@:extern inline private function set_valueStep(v:Float):Float {
		percentStep = v / (max - min);
		valueRound = MathTools.lengthAfterComma(v);
		percentRound = -1;
		return v;
	}
	
	@:extern inline private function get_valueStep():Float return percentStep * (max - min);
	
	override private function moveHandler(t:Touch):Void {
		var p = detectPos(t.x, t.y);
		pos = limit(posStep == 0 ? p : (Math.round(p / posStep) * posStep));
	}
	
	override function changePosHandler(v:Float):Void {
		if (percentRound == -1)
			super.changePosHandler(v);
		else
			percent = MathTools.roundTo(v / size, percentRound);
	}
	
	override function updateValue(v:Float):Void {
		if (valueRound == -1)
			super.updateValue(v);
		else
			value = MathTools.roundTo(min + v * (max - min), valueRound);
	}
	
}