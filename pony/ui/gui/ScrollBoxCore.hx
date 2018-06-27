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
import pony.ui.touch.Touch;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SliderCore;

/**
 * ScrollBoxCore
 * @author AxGord <axgord@gmail.com>
 */
class ScrollBoxCore implements HasSignal {

	@:auto public var onScrollVertPos:Signal2<Float, Float>;
	@:auto public var onScrollVertSize:Signal2<Float, Float>;
	@:auto public var onHideScrollVert:Signal0;
	@:auto public var onScrollHorPos:Signal2<Float, Float>;
	@:auto public var onScrollHorSize:Signal2<Float, Float>;
	@:auto public var onHideScrollHor:Signal0;
	@:auto public var onContentPos:Signal2<Float, Float>;
	@:auto public var onMaskSize:Signal2<Float, Float>;

	public var w(default, null):Float;
	public var h(default, null):Float;
	public var vert(default, null):Bool;
	public var hor(default, null):Bool;

	private var tArea:Touchable;
	private var barVert:ScrollBoxBarCore;
	private var barHor:ScrollBoxBarCore;

	private var cx:Float = 0;
	private var cy:Float = 0;
	private var mw:Float;
	private var mh:Float;

	public function new(w:Float, h:Float, ?tArea:Touchable, ?tScrollerVert:ButtonCore, ?tScrollerHor:ButtonCore, scrollSize:Float = 10, wheelSpeed:Float = 1) {
		this.w = w;
		this.h = h;
		mw = w;
		mh = h;
		this.tArea = tArea;
		if (tScrollerVert != null) {
			barVert = new ScrollBoxBarCore(tScrollerVert, scrollSize, h, w, true, wheelSpeed);
			barVert.onHide << eHideScrollVert;
			barVert.onPos << function(a:Float, b:Float):Void eScrollVertPos.dispatch(b, a);
			barVert.onSize << function(a:Float, b:Float):Void eScrollVertSize.dispatch(b, a);
			barVert.onContentPos << vertContentHandler;
			barVert.onMaskSize << vertMaskSizeHandler;
			if (tArea != null)
				tArea.onWheel << barVert.wheelHandler;
			tScrollerVert.touch.onOver << disableContentDrag;
			tScrollerVert.touch.onOut << enableContentDrag;
			tScrollerVert.touch.onOutUp << enableContentDrag;
		}
		if (tScrollerHor != null) {
			barHor = new ScrollBoxBarCore(tScrollerHor, scrollSize, w, h, false, wheelSpeed);
			barHor.onHide << eHideScrollHor;
			barHor.onPos << eScrollHorPos;
			barHor.onSize << eScrollHorSize;
			barHor.onContentPos << horContentHandler;
			barHor.onMaskSize << horMaskSizeHandler;

			tScrollerHor.touch.onOver << disableContentDrag;
			tScrollerHor.touch.onOut << enableContentDrag;
			tScrollerHor.touch.onOutUp << enableContentDrag;
		}

		enableContentDrag();
	}

	public function disableContentDrag():Void {
		if (tArea != null)
			tArea.onDown >> areaDownHandler;
	}

	public function enableContentDrag():Void {
		
		if (tArea != null)
			tArea.onDown << areaDownHandler;
	}

	private function areaDownHandler(t:Touch):Void {
		t.onMove << areaMoveHandler;
		t.onUp < areaUpHandler;
		t.onOutUp < areaUpHandler;
		if (barVert != null)
			barVert.start(t.y);
		if (barHor != null)
			barHor.start(t.x);
	}

	private function areaMoveHandler(t:Touch):Void {
		if (barVert != null)
			barVert.move(t.y);
		if (barHor != null)
			barHor.move(t.x);
	}

	private function areaUpHandler(t:Touch):Void {
		t.onMove >> areaMoveHandler;
		t.onUp >> areaUpHandler;
		t.onOutUp >> areaUpHandler;
	}

	private function vertMaskSizeHandler(v:Float):Void {
		mw = v;
		updateMaskSize();
	}

	private function horMaskSizeHandler(v:Float):Void {
		mh = v;
		updateMaskSize();
	}

	@:extern private inline function updateMaskSize():Void {
		eMaskSize.dispatch(mw, mh);
	}

	public function content(cw:Float, ch:Float):Void {
		if (barVert != null)
			barVert.content(ch);
		if (barHor != null)
			barHor.content(cw);
	}

	private function vertContentHandler(p:Float):Void {
		cy = p;
		updateContentPos();
	}

	private function horContentHandler(p:Float):Void {
		cx = p;
		updateContentPos();
	}

	@:extern private inline function updateContentPos():Void {
		eContentPos.dispatch(cx, cy);
	}

}