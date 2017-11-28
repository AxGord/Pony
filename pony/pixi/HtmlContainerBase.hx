/**
* Copyright (c) 2012-2017 Alexander Gordeyko <axgord@gmail.com>. All rights reserved.
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
package pony.pixi;

import js.html.CSSStyleDeclaration;
import pony.geom.Rect;
import pony.geom.Point;

/**
 * HtmlContainerBase
 * @author AxGord <axgord@gmail.com>
 */
class HtmlContainerBase {

	public static inline var POSITION:String = 'absolute';

    private var app:App;

	public var targetStyle(default, set):CSSStyleDeclaration;
	public var targetRect(default, set):Rect<Float>;
	public var targetPos(default, set):Point<Float> = new Point(.0, .0);

    public function new(targetRect:Rect<Float>, ?app:App, ?targetStyle:CSSStyleDeclaration) {
		this.targetRect = targetRect;
        if (app == null)
            app = App.main;
        this.app = app;
		this.targetStyle = targetStyle;
		this.targetPos = targetPos;
    }

	private function resizeHandler(scale:Float):Void {
		var rect = app.parentDom.getBoundingClientRect();
		var nx = rect.x + js.Browser.window.scrollX + scale * (targetRect.x + targetPos.x + app.container.x / app.container.width);
		var ny = rect.y + js.Browser.window.scrollY + scale * (targetRect.y + targetPos.y + app.container.y / app.container.height);

		var bw = scale * targetRect.width;
		var bh = scale * targetRect.height;

		resize(nx, ny, bw, bh);
	}

	private function resize(x:Float, y:Float, w:Float, h:Float):Void {
		targetStyle.top = px(y);
		targetStyle.left = px(x);
		targetStyle.width = px(w);
		targetStyle.height = px(h);
	}

	@:extern inline static function px(v:Float):String return v + 'px';

	private function set_targetStyle(s:CSSStyleDeclaration):CSSStyleDeclaration {
		targetStyle = s;

		if (s == null) {
			app.onResize >> resizeHandler;
		} else {
			s.position = POSITION;
			app.onResize << resizeHandler;
			resizeHandler(app.scale);
		}

		return targetStyle;
	}

	private function set_targetRect(v:Rect<Float>):Rect<Float> {
		if (targetRect == null
			|| v.x != targetRect.x
            || v.y != targetRect.y
            || v.width != targetRect.width
            || v.height != targetRect.height
        ) {
			targetRect = v;
			if (targetStyle != null)
				resizeHandler(app.scale);
		}
		return v;
	}

	private function set_targetPos(v:Point<Float>):Point<Float> {
		if (v.x != targetPos.x || v.y != targetPos.y) {
			targetPos = v;
			resizeHandler(app.scale);
		}
		return v;
	}

}