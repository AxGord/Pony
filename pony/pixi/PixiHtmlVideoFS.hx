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
package pony.pixi;

import pony.pixi.App;
import pony.HtmlVideo;
import pony.geom.Rect;
import pony.geom.Border;
import pony.Or;
import pony.Tumbler;

class PixiHtmlVideoFS extends PixiHtmlVideoBase {

	public var fullscreen(default, null) = new Tumbler(false);
	private var normalRect:Rect<Float>;
	private var fsRect:Rect<Float>;

	public function new(targetRect:Rect<Float>, fsRect:Or<Border<Float>, Rect<Float>>, ?app:App, ?options:HtmlVideoOptions) {
		super(targetRect, app, options);
		if (fsRect != null) {
			this.normalRect = targetRect;
			switch fsRect {
				case A(border):
					this.fsRect = border.getRectFromSize(app.resolution);
				case B(rect):
					this.fsRect = rect;
			}
			video.onClick << fullscreen.sw;
			video.onHide || video.onEnd << fullscreen.disable;
			fullscreen.onEnable << openFullScreenHandler;
			fullscreen.onDisable << closeFullScreenHandler;
			video.style.cursor = 'pointer';
		}
	}

	public function openFullScreenHandler():Void {
		targetRect = fsRect;
	}

	public function closeFullScreenHandler():Void {
		targetRect = normalRect;
	}

}