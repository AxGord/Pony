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
package pony.html;

import js.html.MouseEvent;

/**
 * Frame horizontal resizer
 * @author AxGord <axgord@gmail.com>
 */
class FrameHResizer extends FrameBaseResizer {

	public function new(frameA:String, resizer:String, frameB:String, frameAMin:Int, frameBMin:Int) {
		super(frameA, resizer, frameB, frameAMin, frameBMin);
	}

	override private function get_sizeA():Int return frameA.clientHeight;
	override private function get_sizeB():Int return frameB.clientHeight;

	override private function set_posA(v:Int):Int {
		frameA.style.height = v + 'px';
		return v;
	}

	override private function set_posB(v:Int):Int {
		frameB.style.bottom = v + 'px';
		resizer.style.bottom = (v - (resizer.clientHeight / 2)) + 'px';
		return v;
	}

	override private function getMousePos(e:MouseEvent):Int return e.clientY;

}