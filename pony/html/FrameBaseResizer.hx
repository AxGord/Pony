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

import js.Browser;
import js.html.Element;
import js.html.MouseEvent;
import pony.events.Signal0;

/**
 * Frame resizer base class
 * @author AxGord <axgord@gmail.com>
 */
class FrameBaseResizer implements pony.magic.HasSignal implements pony.magic.HasAbstract {

	@:auto public var onResize:Signal0;

	private var frameA:Element;
	private var frameB:Element;
	private var resizer:Element;

	private var startMousePos:Int;
	private var startSize:Int;
	private var frameAMin:Int;
	private var frameBMin:Int;

	private var sizeA(get, never):Int;
	private var sizeB(get, never):Int;
	private var posA(never, set):Int;
	private var posB(never, set):Int;

	private function new(frameA:String, resizer:String, frameB:String, frameAMin:Int, frameBMin:Int) {
		this.frameA = Browser.document.getElementById(frameA);
		this.frameB = Browser.document.getElementById(frameB);
		this.resizer = Browser.document.getElementById(resizer);
		this.frameAMin = frameAMin;
		this.frameBMin = frameBMin;
		this.resizer.addEventListener('mousedown', mouseDownHandler);
		Browser.window.addEventListener('mouseup', mouseUpHandler);
		Browser.window.addEventListener('resize', update);
		posB = sizeA;
	}

	@:abstract private function get_sizeA():Int;
	@:abstract private function get_sizeB():Int;
	@:abstract private function set_posA(v:Int):Int;
	@:abstract private function set_posB(v:Int):Int;
	@:abstract private function getMousePos(e:MouseEvent):Int;

	private function mouseDownHandler(e:MouseEvent):Void {
		startMousePos = getMousePos(e);
		startSize = sizeA;
		Browser.window.addEventListener('mousemove', mouseMoveHandler);
	}

	private function mouseMoveHandler(e:MouseEvent):Void {
		resize(startSize + (startMousePos - getMousePos(e)));
		e.stopPropagation();
	}

	private function mouseUpHandler(e:MouseEvent):Void {
		Browser.window.removeEventListener('mousemove', mouseMoveHandler);
	}

	private function resize(nh:Int):Void {
		if (nh < this.frameAMin)
			nh = this.frameAMin;
		if (nh != sizeA) {
			posB = nh;
			checkB(nh);
		}
	}

	private function update():Void checkB(sizeA);

	private function checkB(nh:Int):Void {
		if (sizeB < frameBMin) {
			posB = 0;
			nh = sizeB - frameBMin;
			posB = nh;
			if (nh != sizeA) {
				posA = nh;
				eResize.dispatch();
			}
		} else {
			posA = nh;
			posB = nh;
			eResize.dispatch();
		}
	}

}