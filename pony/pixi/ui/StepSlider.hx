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
package pony.pixi.ui;

import pixi.core.Pixi;
import pixi.core.display.Container;
import pixi.core.sprites.Sprite;
import pony.geom.Border;
import pony.geom.Point;
import pony.ui.gui.StepSliderCore;

/**
 * StepSlider
 * @author AxGord <axgord@gmail.com>
 */
class StepSlider extends Sprite {

	public var sliderCore:StepSliderCore;
	public var labelButton:LabelButton;
	
	public function new(
		labelButton:LabelButton,
		w:Float,
		h:Float,
		invert:Bool = false,
		draggable:Bool = true
	) {
		super();
		this.labelButton = labelButton;
		addChild(labelButton);
		sliderCore = StepSliderCore.create(labelButton.core, w, h, invert, draggable);
		sliderCore.changeX = changeXHandler;
		sliderCore.changeY = changeXHandler;
	}
	
	private function changeXHandler(v:Float):Void labelButton.x = v;
	private function changeYHandler(v:Float):Void labelButton.y = v;
	
	public function add(obj:Container):Void labelButton.add(obj);
	
}