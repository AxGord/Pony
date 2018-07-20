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

import pony.events.Signal0;
import pony.events.Signal1;
import pony.events.Signal2;
import pony.magic.HasSignal;
import pony.ui.touch.Touchable;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SliderCore;

/**
 * ScrollBoxBarCore
 * @author AxGord <axgord@gmail.com>
 */
class ScrollBoxBarCore implements HasSignal {

	@:auto public var onHide:Signal0;
	@:auto public var onPos:Signal2<Float, Float>;
	@:auto public var onSize:Signal2<Float, Float>;
	@:auto public var onContentPos:Signal1<Float>;
	@:auto public var onMaskSize:Signal1<Float>;

	public var c(default, null):Null<Float>;
	private var slider:SliderCore;
	private var scrollPanelSize:Float;
	public var totalA(default, set):Float;
	public var totalB(default, set):Float;
	private var scrollerSize:Float;
	private var startPoint:Float;

	public function new(t:ButtonCore, scrollPanelSize:Float, totalA:Float, totalB:Float, vert:Bool, wheelSpeed:Float) {
		slider = new SliderCore(t, 0, vert);
		slider.wheelSpeed = wheelSpeed;
		this.scrollPanelSize = scrollPanelSize;
		this.totalA = totalA;
		this.totalB = totalB;
		if (vert) {
			slider.changeY = posHandler;
		} else {
			slider.changeX = posHandler;
		}
		slider.changeValue << valueHandler;
	}

	private function set_totalA(v:Float):Float {
		if (v != totalA) {
			totalA = v;
			if (c != null)
				content(c);
		}
		return v;
	}

	private function set_totalB(v:Float):Float {
		if (v != totalB) {
			totalB = v;
			if (c != null)
				content(c);
		}
		return v;
	}

	public function content(c:Float):Void {
		this.c = c;
		if (c <= totalA) {
			slider.setSize(0.1);
			eHide.dispatch();
			eContentPos.dispatch(0);
			eMaskSize.dispatch(totalB);
		} else {
			scrollerSize = totalA * totalA / c;
			slider.setSize(totalA - scrollerSize);
			eSize.dispatch(scrollerSize, scrollPanelSize);
			eMaskSize.dispatch(totalB - scrollPanelSize);
			slider.initValue(0, c - totalA);
			slider.update();
		}
	}

	private function posHandler(pos:Float):Void {
		ePos.dispatch(pos, totalB - scrollPanelSize);
	}

	private function valueHandler(v:Float):Void {
		eContentPos.dispatch(-v);

	}

	public function wheelHandler(delta:Int):Void {
		slider.wheel(delta);
	}

	public function start(p:Float):Void {
		startPoint = slider.value + p;
	}

	public function move(p:Float):Void {
		slider.setPosValue(startPoint - p);
	}

}