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

import pony.JsTools;
import pony.HtmlVideo;
import pony.geom.Rect;
import pony.geom.Border;
import pony.geom.Point;
import pony.Or;
import pony.Tumbler;
import pony.time.DeltaTime;
import pony.time.Time;
import pony.time.DTimer;

class HtmlVideoUIFS extends HtmlVideoUI {

	public var fullscreen(default, null) = new Tumbler(false);
	private var normalRect:Rect<Float>;
	private var fsRect:Rect<Float>;
	private var normalPos:Point<Float>;
	private var normalCss:String;
	private var fsCss:String;
	private var transition:String;
	private var transitionDelay:DTimer;

	public function new(
		targetRect:Rect<Float>,
		fsRect:Or<Border<Float>, Rect<Float>>,
		?fsPos:Point<Float>,
		?css:String,
		?fscss:String,
		?transition:String,
		?app:pony.pixi.App,
		?options:HtmlVideoOptions,
		fixed:Bool = false)
	{
		if (css != null) {
			css = JsTools.normalizeCss(css);
			normalCss = css;
		}
		super(targetRect, css, app, options, fixed);
		if (fsRect != null) {
			this.normalRect = targetRect;
			generateTransition(transition);
			switch fsRect {
				case A(border):
					this.fsRect = border.getRectFromSize(app.resolution);
				case B(rect):
					this.fsRect = rect;
			}
			if (fsPos != null) {
				this.fsRect.x += fsPos.x;
				this.fsRect.y += fsPos.y;
			}
			video.onClick << fullscreen.sw;
			(video.loadProgress.changeRun - false - true) || video.onEnd << fullscreen.disable;
			fullscreen.onEnable << openFullScreenHandler;
			fullscreen.onDisable << closeFullScreenHandler;
			video.style.cursor = 'pointer';

			if (fscss != null) {
				fsCss = JsTools.normalizeCss(fscss);
			}
		}
	}

	private function generateTransition(tr:String):Void {
		if (tr == null) return;
		var a = tr.split(' ');
		var t = a.shift();
		var r = [for (e in a) '$e $t'].join(', ');
		transition = JsTools.normalizeCss('transition: ' + r + '; -webkit-transition: ' + r + ';');
		transitionDelay = DTimer.createFixedTimer((t:Time) + 10);
		transitionDelay.complete << removeTransition;
	}

	private function addTransition():Void {
		if (transition != null) {
			video.style.cssText += transition;
			transitionDelay.reset();
			transitionDelay.start();
		}
	}

	private function removeTransition():Void {
		var css = JsTools.splitCss(video.style.cssText);
		var t = JsTools.splitCss(transition);
		var ncss:Array<String> = [];
		for (e in css) if (t.indexOf(e) == -1) ncss.push(e);
		video.style.cssText = ncss.join('');
	}

	public function openFullScreenHandler():Void {
		addTransition();
		normalPos = htmlContainer.targetPos;
		htmlContainer.targetPos = new Point<Float>(0, 0);
		targetRect = fsRect;
		if (transition == null)
			_openFullScreenHandler();
		else
			transitionDelay.complete < _openFullScreenHandler;
	}

	private function _openFullScreenHandler():Void switchCss(normalCss, fsCss);

	public function closeFullScreenHandler():Void {
		addTransition();
		htmlContainer.targetPos = normalPos;
		normalPos = null;
		targetRect = normalRect;
		switchCss(fsCss, normalCss);
	}

	private function switchCss(a:String, b:String):Void {
		var css = JsTools.splitCss(video.style.cssText);
		var ncss:Array<String> = null;
		if (a != null) {
			ncss = [];
			var r = JsTools.splitCss(a);
			for (e in css) {
				if (r.indexOf(e) == -1)
					ncss.push(e);
			}
		} else {
			ncss = css;
		}
		if (b != null) {
			video.style.cssText = ncss.join('') + b;
		} else {
			video.style.cssText = ncss.join('');
		}
	}

}