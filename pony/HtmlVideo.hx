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
package pony;

import js.html.CSSStyleDeclaration;
import js.html.VideoElement;
import js.html.SourceElement;
import pony.events.Signal0;
import pony.time.DTimer;
import pony.Tumbler;
import pony.Percent;
import pony.JsTools;
import pony.time.Time;
import pony.magic.HasSignal;
import pony.magic.HasLink;

typedef HtmlVideoOptions = {
	?bufferingTreshhold: Int,
	?retryDelay: Int,
	?maxRetries: Int,
	?virtualPlay: Bool
}

/**
 * HtmlVideo
 * @author AxGord <axgord@gmail.com>
 */
class HtmlVideo implements HasSignal implements HasLink {

	@:auto public var onClick:Signal0;
	public var onEnd(link, never):Signal0 = position.onEnd;

	@:bindable public var resultVisible:Bool = true;
	public var visible(default, null):Tumbler = new Tumbler(true);
	public var loadProgress(link, null):Percent = loadState.progress;
	public var playProgress(link, null):Percent = position.progress;
	public var muted:Tumbler = new Tumbler(true);
	public var muted1:Tumbler = new Tumbler(true);
	public var muted2:Tumbler = new Tumbler(true);

	public var qualities(link, set):Array<String> = loader.qualities;
	public var qualityIndex(link, set):Int = loader.qualityIndex;

	public var qualityUpSpeed(link, set):Float = loadState.qualityUpSpeed;
	public var qualityDownSpeed(link, set):Float = loadState.qualityDownSpeed;

	public var url(default, null):String;

	public var loader:HtmlVideoLoader;
	public var loadState:HtmlVideoLoadProgress;
	private var position:HtmlVideoPlayProgress;

	private var options:HtmlVideoOptions = {
		bufferingTreshhold: 3,
		retryDelay: 10000,
		maxRetries: 4,
		virtualPlay: true
	};

	public var videoElement(default, null):VideoElement;
	public var style(get, never):CSSStyleDeclaration;
	public var startTime(default, set):Time = 0;

	public function new(?options:HtmlVideoOptions) {
		
		if (options != null) {
			if (options.bufferingTreshhold != null)
				this.options.bufferingTreshhold = options.bufferingTreshhold;
			if (options.retryDelay != null)
				this.options.retryDelay = options.retryDelay;
			if (options.maxRetries != null)
				this.options.maxRetries = options.maxRetries;
			if (options.virtualPlay != null)
				this.options.virtualPlay = options.virtualPlay;
		}

		createVideoElement();

		loader = new HtmlVideoLoader(videoElement, this.options.retryDelay, this.options.maxRetries);
		loadState = new HtmlVideoLoadProgress(videoElement, this.options.bufferingTreshhold);
		position = new HtmlVideoPlayProgress(videoElement);

		position.changePosition << function(v:Time) loadState.targetTime = v;
		position.onSync << playVideo;

		loader.onUnload << loadState.reset;
		loader.onUnload << position.reset;

		loadState.onReady << setActualMuted;

		visible.changeEnabled << updateResultVisible;
		loadProgress.changeRun << updateResultVisible;

		changeResultVisible - true << showHtmlElement;
		changeResultVisible - false << hideHtmlElement;

		resultVisible = false;

		muted.onEnable << muteHandler;
		muted.onDisable << unmuteHandler;
		muted1.changeEnabled << muteUpdate;
		muted2.changeEnabled << muteUpdate;

		loadState.onQualityUp << loader.qualityUp;
		loadState.onQualityDown << loader.qualityDown;
	}

	@:extern private inline function set_qualities(q:Array<String>):Array<String> return loader.qualities = q; 
	@:extern private inline function set_qualityIndex(q:Int):Int return loader.qualityIndex = q;
	@:extern private inline function set_qualityUpSpeed(v:Float):Float return loadState.qualityUpSpeed = v;
	@:extern private inline function set_qualityDownSpeed(v:Float):Float return loadState.qualityDownSpeed = v;

	private function muteUpdate():Void muted.enabled = muted1.enabled || muted2.enabled;
	
	@:extern private inline function createVideoElement():Void {
		videoElement = cast js.Browser.document.createElement('video');
		videoElement.setAttribute('playsinline', 'playsinline'); // for ios
		videoElement.muted = true; // must be muted to play on mobiles
		videoElement.autoplay = true; // for mobiles + desktop
		videoElement.controls = false;
		videoElement.loop = false;
		videoElement.preload = 'auto';
		videoElement.addEventListener('canplay', playVideo);
		videoElement.addEventListener('pause', playVideo);
		videoElement.addEventListener('mousedown', videoClickHandler);
		videoElement.addEventListener('touchstart', videoClickHandler);
	}

	public inline function loadVideo(url:String):Void {
		this.url = url;
		loader.loadVideo(url);
		loadState.enable();
		play();
	}

	public inline function unloadVideo():Void {
		url = null;
		stop();
		loadState.disable();
		loader.unloadVideo();
		position.dispathEnd();
		startTime = 0;
	}

	public function reloadVideo():Void {
		if (url == null) return;
		var u:String = url;
		var p:Time = position.position;
		url = null;
		stop();
		loadState.disable();
		loader.unloadVideo();
		loadVideo(u);
		startTime = p;
		playVideo();
	}
	
	public function play():Void {
		if (options.virtualPlay) position.enable();
	}

	public function stop():Void {
		if (options.virtualPlay) position.disable();
	}

	@:extern private inline function set_startTime(v:Time):Time return position.start = v;

	private function muteHandler():Void videoElement.muted = true;
	private function unmuteHandler():Void if (loadProgress.run) videoElement.muted = false;
	private function setActualMuted():Void videoElement.muted = muted.enabled;

	private function updateResultVisible():Void {
		resultVisible = visible.enabled && loadProgress.run;
	}

	@:extern private inline function get_muted():Bool return videoElement.muted;
	@:extern private inline function set_muted(v:Bool):Bool return videoElement.muted = v;

	@:extern public inline function appendTo(parent:js.html.DOMElement):Void parent.appendChild(videoElement);
	@:extern private inline function get_style():CSSStyleDeclaration return videoElement.style;

	private function showHtmlElement():Void videoElement.style.display = 'block';
	private function hideHtmlElement():Void videoElement.style.display = 'none';

	private function videoClickHandler():Void eClick.dispatch();

	private function playVideo():Void {
		if (loadProgress.run) {
			if (!loader.isPlaying) {
				try {
					videoElement.play();
				} catch (_:Any) {
					DTimer.fixedDelay(1000, playVideo);
				}
				if (!pony.JsTools.isMobile)
					videoElement.muted = muted.enabled;
			}
		}
	}

}

@:final private class HtmlVideoLoader implements HasSignal {

	@:auto public var onLoad:Signal0;
	@:auto public var onUnload:Signal0;

	public var isPlaying(get, never):Bool;

	public var qualities(default, set):Array<String> = null;
	public var qualityIndex:Int = 1;

	private var element:VideoElement;
	private var videoSource:SourceElement;
	private var retryCount:Int = 0;
	private var unloaded:Bool = true;
	private var retryDelay:Int;
	private var maxRetries:Int;

	public function new(videoElement:VideoElement, retryDelay:Int, maxRetries:Int) {
		element = videoElement;
		this.retryDelay = retryDelay;
		this.maxRetries = maxRetries;
	}

	@:extern private inline function get_isPlaying():Bool {
		return element.currentTime > 0 &&
			!element.paused &&
			!element.ended &&
			element.readyState > 2;
	}

	public function loadVideo(url:String):Void {
		if (qualities != null) {
			url = StringTools.replace(url, '{quality}', qualities[qualityIndex]);
			url = StringTools.replace(url, '/quality/', '/' + qualities[qualityIndex] + '/');
		}
		var playingbefore = isPlaying;
		_unloadVideo();
		videoSource = cast js.Browser.document.createElement('source'); // must play from <source> not .src coz mobile browsers are retarded
		videoSource.addEventListener('error', videoSourceErrorHandler);
		videoSource.src = url;
		element.appendChild(videoSource);
		if (!playingbefore)
			element.load();
		unloaded = false;
		eLoad.dispatch();
	}

	public inline function unloadVideo():Void {
		if (unloaded) {
			_unloadVideo();
		} else {
			var playingbefore = isPlaying;
			_unloadVideo();
			if (playingbefore)
				element.load();
		}
	}

	private function _unloadVideo():Void {
		eUnload.dispatch();
		element.muted = true;
		retryCount = 0;
		if (unloaded) return;
		if (videoSource != null) {
			videoSource.src = '';
			videoSource.removeEventListener('error', videoSourceErrorHandler);
			element.removeChild(videoSource);
			videoSource = null;
		}
		element.removeAttribute('src');
		unloaded = true;
	}

	private function videoSourceErrorHandler(e:js.Error):Void DTimer.fixedDelay(retryDelay, retryConnect);

	private function retryConnect():Void {
		if (videoSource != null && retryCount < maxRetries) {
			loadVideo(videoSource.src);
			retryCount++;
		}
	}

	@:extern private inline function set_qualities(q:Array<String>):Array<String> {
		if (qualityIndex >= q.length)
			qualityIndex = q.length - 1;
		return qualities = q;
	}

	public function qualityUp():Void {
		if (qualities != null && qualityIndex < qualities.length - 1) qualityIndex++;
	}

	public function qualityDown():Void {
		if (qualities != null && qualityIndex > 0) qualityIndex--;
	}

}

@:final private class HtmlVideoPlayProgress extends Tumbler {

	@:bindable public var position:Time;
	@:auto public var onEnd:Signal0;
	@:auto public var onSync:Signal0;

	public var progress(default, null):Percent = new Percent();
	public var current(get, never):Time;
	public var start(default, set):Time = 0;
	public var total(default, null):Time;
	public var elementCurrentTime(get, set):Float;

	private var element:VideoElement;
	private var timer:DTimer;
	private var ended:Bool = false;

	public function new(videoElement:VideoElement) {
		super(false);
		element = videoElement;
		element.addEventListener('timeupdate', timeupdateHandler);
		element.addEventListener('progress', progressHandler);
		element.addEventListener('ended', endedHandler);
		progress.changeFull - true << endedHandler;
		timer = DTimer.createFixedTimer(1000, -1);
		timer.complete << tick;
		onEnable << enableHandler;
		onDisable << disableHandler;
	}

	public inline function dispathEnd():Void eEnd.dispatch(true);

	@:abstract private inline function get_elementCurrentTime():Float {
		return try element.currentTime catch (_:Any) 0;
	}

	@:abstract private inline function set_elementCurrentTime(v:Float):Float {
		try {
			element.currentTime = v;
		} catch (_:Any) {}
		return v;
	}

	private function enableHandler():Void {
		timer.start();
	}

	private function disableHandler():Void {
		timer.stop();
	}

	@:extern private inline function get_current():Time return Time.fromSeconds(Std.int(element.currentTime));

	private function set_start(v:Time):Time {
		if (v != start) {
			start = v;
			progress.current = elementCurrentTime = v.totalSeconds;
			position = v;
		}
		return v;
	}

	private function timeupdateHandler():Void {
		if (ended) {
			element.pause();
			dispathEnd();
		} else {
			progress.current = elementCurrentTime;
		}
	}

	private function progressHandler():Void {
		if (total == null && element.duration > 0) {
			var t = Time.fromSeconds(Std.int(element.duration));
			if (start >= t) {
				eEnd.dispatch();
			} else {
				total = t;
				position = start;
				progress.current = elementCurrentTime = start.totalSeconds;
				progress.total = total;
			}
		}
	}

	private function endedHandler():Void {
		if (!ended) {
			ended = true;
			eEnd.dispatch();
		}
	}

	public function reset():Void {
		timer.reset();
		total = null;
		ended = false;
		start = 0;
		progress.total = -1;
	}

	private function tick():Void {
		position += 1000;
		if (!pony.math.MathTools.approximately(position.totalSeconds, progress.current, 3)) {
			progress.current = elementCurrentTime = position.totalSeconds;
			eSync.dispatch();
		}
	}

}

@:final private class HtmlVideoLoadProgress extends Tumbler implements HasSignal {
	
	@:bindable public var loading:Bool = false;
	@:auto public var onReady:Signal0;
	@:auto public var onLoad:Signal0;

	@:auto public var onQualityUp:Signal0;
	@:auto public var onQualityDown:Signal0;
	public var onFullLoad(default, null):Signal0;

	public var qualityUpSpeed:Float = 1.5;
	public var qualityDownSpeed:Float = 0.8;

	public var progress(default, null):Percent = new Percent(0);
	public var targetTime(default, set):Time = null;
	private var element:VideoElement;
	private var bufferingTreshhold:Float;
	private var isReady(get, never):Bool;
	private var beginLoadTime:Float;
	private var posOnBegin:Bool = true;

	public function new(videoElement:VideoElement, bufferingTreshhold:Float) {
		super(false);
		element = videoElement;
		this.bufferingTreshhold = bufferingTreshhold;
		element.addEventListener('progress', updateVideoLoadPercentage);
		element.addEventListener('loadeddata', updateVideoLoadPercentage);
		progress.changeRun << changeRunHandler;
		onDisable << reset;
		changeEnabled << updateLoading;
		//load speed calc
		onEnable << startLoadHandler;
		onFullLoad = progress.changeFull - true;
	}

	private function startLoadHandler():Void {
		if (targetTime.totalSeconds <= 3) {
			beginLoadTime = Date.now().getTime();
			onFullLoad < endLoadHandler;
			onDisable < slowSpeedDetected;
		} else {
			beginLoadTime = null;
		}
	}

	private function slowSpeedDetected():Void {
		onFullLoad >> endLoadHandler;
		var time = (Date.now().getTime() - beginLoadTime) / 1000;
		if (time - beginLoadTime > 10)
			eQualityDown.dispatch();
	}

	private function endLoadHandler():Void {
		onDisable >> slowSpeedDetected;
		var time = (Date.now().getTime() - beginLoadTime) / 1000;
		var p = element.duration / time;
		// trace('Test results: ', p, element.duration, time);
		if (p > qualityUpSpeed)
			eQualityUp.dispatch();
		else if (p < qualityDownSpeed)
			eQualityDown.dispatch();
		beginLoadTime = null;
	}
	
	@:extern private inline function get_isReady():Bool {
		return enabled &&
			element.readyState > 2 &&
			element.duration != 0 &&
			element.buffered.length > 0;
	}

	private function set_targetTime(v:Time):Time {
		if (v != targetTime) {
			if (progress.total != -1 && enabled && posOnBegin) {
				onFullLoad >> endLoadHandler;
				onDisable >> slowSpeedDetected;
			}
			targetTime = v;
			progress.allow = v.totalSeconds + bufferingTreshhold;
			if (progress.total != -1 && enabled) {
				if (posOnBegin) {
					startLoadHandler();
				} else {
					eQualityDown.dispatch();
				}
				posOnBegin = false;
			}
		}
		return v;
	}

	public function reset():Void {
		posOnBegin = true;
		progress.allow = bufferingTreshhold;
		progress.current = 0;
		progress.total = -1;
	}

	private function changeRunHandler(v:Bool):Void {
		if (v)
			eReady.dispatch();
		else
			eLoad.dispatch();
		updateLoading();
	}

	private function updateVideoLoadPercentage():Void {
		if (isReady) {
			progress.total = Std.int(element.duration);
			progress.current = Std.int(element.buffered.end(element.buffered.length - 1));
		} else {
			progress.current = 0;
		}
	}

	private function updateLoading():Void loading = enabled && !progress.run;

}