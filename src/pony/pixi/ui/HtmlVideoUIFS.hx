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

/**
 * HtmlVideoUIFS
 * @author AxGord <axgord@gmail.com>
 */
class HtmlVideoUIFS extends HtmlVideoUI {

	public var fullscreen(default, null) = new Tumbler(false);
	private var normalRect:Rect<Float>;
	private var fsRect:Rect<Float>;
	private var normalPos:Point<Float>;
	private var normalCss:String;
	private var fsCss:String;
	private var transition:String;
	private var transitionDelay:DTimer;
	private var hideTransition:String;
	public var hideTransitionDelay(default, null):DTimer;
	private var showTransition:String;
	public var showTransitionDelay(default, null):DTimer;
	private var clickTimer:DTimer;
	private var showAnimTime:Time = 500;
	private var hideAnimTime:Time = 200;
	private var fsHold:Bool = false;
	private var hideProcess:Bool = false;
	private var showProcess:Bool = false;

	public function new(
		targetRect:Rect<Float>,
		fsRect:Or<Border<Float>, Rect<Float>>,
		?fsPos:Point<Float>,
		?css:String,
		?fscss:String,
		?transition:String,
		?app:pony.pixi.App,
		?options:HtmlVideoOptions,
		?clickTimeout:Time,
		ceil:Bool = false,
		fixed:Bool = false)
	{
		if (css != null) {
			css = JsTools.normalizeCss(css);
			normalCss = css;
		}
		super(targetRect, css, app, options, ceil, fixed);
		if (fsRect != null) {
			this.normalRect = targetRect;
			generateTransition(transition);
			switch fsRect {
				case A(border):
					this.fsRect = border.getRectFromSize(app.stageInitSize);
				case B(rect):
					this.fsRect = rect;
			}
			if (fsPos != null) {
				this.fsRect.x += fsPos.x;
				this.fsRect.y += fsPos.y;
			}
			if (clickTimeout == null) {
				video.onClick << fullscreen.sw;
			} else {
				clickTimer = DTimer.createFixedTimer(clickTimeout);
				listenClick();
				clickTimer.complete << listenClick;
			}
			(video.loadProgress.changeRun - false - true) || video.onEnd << fullscreen.disable;
			fullscreen.onEnable << openFullScreenHandler;
			fullscreen.onDisable << closeFullScreenHandler;
			video.style.cursor = 'pointer';

			if (fscss != null) {
				fsCss = JsTools.normalizeCss(fscss);
			}
		}
		createShowAndHideTransitions();
	}

	@:extern private inline function createShowAndHideTransitions():Void {
		hideTransition = getTransition('opacity ' + hideAnimTime.totalMs + 'ms');
		hideTransitionDelay = DTimer.createFixedTimer(hideAnimTime);
		hideTransitionDelay.complete << removeHideTransition;
		hideTransitionDelay.complete << hide;
		showTransition = getTransition('opacity ' + showAnimTime.totalMs + 'ms ease-in');
		showTransitionDelay = DTimer.createFixedTimer(showAnimTime);
		showTransitionDelay.complete << removeShowTransition;
		showTransitionDelay.complete << video.enableTouch;
	}

	public inline function animHide():Void {
		if (fsHold) return;
		hideTransitionDelay.complete >> _animShow;
		if (!showProcess)
			_animHide();
		else
			showTransitionDelay.complete < _animHide;
	}

	private inline function _animHide():Void {
		if (fsHold) return;
		hideTransitionDelay.complete >> _animShow;
		hideProcess = true;
		video.disableTouch();
		addHideTransition();
		video.style.opacity = '0';
	}

	public inline function animShow():Void {
		if (fsHold) return;
		showTransitionDelay.complete >> _animHide;
		if (!hideProcess)
			_animShow();
		else
			hideTransitionDelay.complete < _animShow;
	}

	private function _animShow():Void {
		if (fsHold) return;
		showTransitionDelay.complete >> _animHide;
		showProcess = true;
		show();
		video.style.opacity = '0';
		addShowTransition();
		video.style.opacity = '1';
	}

	private inline function listenClick():Void video.onClick < clickHandler;

	private function clickHandler():Void {
		fullscreen.sw();
		clickTimer.reset();
		clickTimer.start();
	}

	private inline function getTransition(r:String):String {
		return JsTools.normalizeCss('transition: ' + r + '; -webkit-transition: ' + r + ';');
	}

	private function generateTransition(tr:String):Void {
		if (tr == null) return;
		var a = tr.split(' ');
		var t = a.shift();
		var r = [for (e in a) '$e $t'].join(', ');
		transition = getTransition(r);
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

	private function addShowTransition():Void {
		if (showTransition != null) {
			video.style.cssText += showTransition;
			showTransitionDelay.reset();
			showTransitionDelay.start();
		}
	}

	private function addHideTransition():Void {
		if (hideTransition != null) {
			video.style.cssText += hideTransition;
			hideTransitionDelay.reset();
			hideTransitionDelay.start();
		}
	}

	private function removeTransition():Void rmTransition(transition);

	private function removeHideTransition():Void {
		rmTransition(hideTransition);
		hideProcess = false;
	}

	private function removeShowTransition():Void {
		rmTransition(showTransition);
		showProcess = false;
	}

	private function rmTransition(tr:String):Void {
		var css = JsTools.splitCss(video.style.cssText);
		var t = JsTools.splitCss(tr);
		var ncss:Array<String> = [];
		for (e in css) if (t.indexOf(e) == -1) ncss.push(e);
		video.style.cssText = ncss.join('');
	}

	public function openFullScreenHandler():Void {
		fsHold = true;
		addTransition();
		normalPos = htmlContainer.targetPos;
		htmlContainer.targetPos = new Point<Float>(0, 0);
		targetRect = fsRect;
		if (transition == null)
			_openFullScreenHandler();
		else
			transitionDelay.complete < _openFullScreenHandler;
	}

	private function _openFullScreenHandler():Void {
		switchCss(normalCss, fsCss);
		fsHold = false;
	}

	public function closeFullScreenHandler():Void {
		fsHold = true;
		addTransition();
		transitionDelay.complete < _closeFullScreenHandler;
		htmlContainer.targetPos = normalPos;
		normalPos = null;
		targetRect = normalRect;
		switchCss(fsCss, normalCss);
	}

	private function _closeFullScreenHandler():Void {
		fsHold = false;
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