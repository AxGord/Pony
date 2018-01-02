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
package pony.flash.ui;

import flash.display.DisplayObject;
import flash.display.MovieClip;
import pony.math.MathTools;
import pony.time.DeltaTime;
import pony.ui.gui.StepSliderCore;
import pony.flash.FLStage;

/**
 * StepSlider
 * @author AxGord <axgord@gmail.com>
 */
class StepSlider extends MovieClip implements FLStage {
#if !starling
	public var core(default, null):StepSliderCore;
	private var _invert:Bool = false;
	@:stage private var b:Button;
	@:stage private var bg:DisplayObject;
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
	}
	
	private function init():Void {
		core = StepSliderCore.create(b.core, bg.width-b.width, bg.height-b.height, _invert);
		core.changeX = function(v) b.x = v; 
		core.changeY = function(v) b.y = v; 
		core.endInit();
	}
	
	private function invert():Void _invert = true;
#end
}