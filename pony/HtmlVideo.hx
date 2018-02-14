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
	?maxRetries: Int
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
	public var muted:Tumbler = new Tumbler(false);

	private var loader:HtmlVideoLoader;
	private var loadState:HtmlVideoLoadProgress;
	private var position:HtmlVideoPlayProgress;

	private var options:HtmlVideoOptions = {
		bufferingTreshhold: 3,
		retryDelay: 3000,
		maxRetries: 4
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
		}

		createVideoElement();

		loader = new HtmlVideoLoader(videoElement, this.options.retryDelay, this.options.maxRetries);
		loadState = new HtmlVideoLoadProgress(videoElement, this.options.bufferingTreshhold);
		position = new HtmlVideoPlayProgress(videoElement);

		loader.onUnload << loadState.reset;
		loader.onUnload << position.reset;

		loadState.onReady << setActualMuted;

		visible.changeEnabled << updateResultVisible;
		loadProgress.changeRun << updateResultVisible;

		changeResultVisible - true << showHtmlElement;
		changeResultVisible - false << hideHtmlElement;

		resultVisible = false;

		if (!JsTools.isMobile) {
			muted.onEnable << muteHandler;
			muted.onDisable << unmuteHandler;
		}
	}
	
	@:extern private inline function createVideoElement():Void {
		videoElement = cast js.Browser.document.createElement('video');
		videoElement.setAttribute('playsinline', 'playsinline'); // for ios
		videoElement.muted = true; // must be muted to play on mobiles
		videoElement.autoplay = true; // for mobiles + desktop
		videoElement.controls = false;
		videoElement.loop = false;
		videoElement.addEventListener('canplay', playVideo);
		videoElement.addEventListener('pause', playVideo);
		videoElement.addEventListener('click', videoClickHandler);
	}

	public inline function loadVideo(url:String):Void loader.loadVideo(url);
	public inline function unloadVideo():Void loader.unloadVideo();

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
				videoElement.play();
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
		if (retryCount < maxRetries) {
			loadVideo(videoSource.src);
			retryCount++;
		}
	}

}

@:final private class HtmlVideoPlayProgress implements HasSignal {

	@:auto public var onEnd:Signal0;

	public var progress(default, null):Percent = new Percent();
	public var current(get, never):Time;
	public var start(default, set):Time = 0;
	public var total(default, null):Time;

	private var element:VideoElement;

	public function new(videoElement:VideoElement) {
		element = videoElement;
		element.addEventListener('timeupdate', timeupdateHandler);
		element.addEventListener('progress', progressHandler);
		element.addEventListener('ended', endedHandler);
	}

	@:extern private inline function get_current():Time return Time.fromSeconds(Std.int(element.currentTime));

	private function set_start(v:Time):Time {
		if (v != start) {
			start = v;
			progress.current = element.currentTime = v.totalSeconds;
		}
		return v;
	}

	private function timeupdateHandler():Void progress.current = element.currentTime;

	private function progressHandler():Void {
		if (total == null && element.duration > 0) {
			total = Time.fromSeconds(Std.int(element.duration));
			progress.current = element.currentTime = start.totalSeconds;
			progress.total = total;
		}
	}

	private function endedHandler():Void eEnd.dispatch();

	public function reset():Void {
		total = null;
		progress.current = 0;
		progress.total = -1;
	}

}

@:final private class HtmlVideoLoadProgress implements HasSignal {
	
	@:auto public var onReady:Signal0;
	@:auto public var onLoad:Signal0;

	public var progress(default, null):Percent = new Percent(0);
	public var targetTime(default, set):Time = 0;
	private var element:VideoElement;
	private var bufferingTreshhold:Float;
	private var isReady(get, never):Bool;

	public function new(videoElement:VideoElement, bufferingTreshhold:Float) {
		element = videoElement;
		this.bufferingTreshhold = bufferingTreshhold;
		element.addEventListener('progress', updateVideoLoadPercentage);
		element.addEventListener('loadeddata', updateVideoLoadPercentage);
		progress.changeRun << changeRunHandler;
	}
	
	@:extern private inline function get_isReady():Bool {
		return element.readyState > 2 &&
			element.duration != 0 &&
			element.buffered.length > 0;
	}

	private function set_targetTime(v:Time):Time {
		if (v == targetTime) {
			targetTime = v;
			progress.allow = v.totalSeconds + bufferingTreshhold;
		}
		return v;
	}

	public function reset():Void {
		progress.allow = bufferingTreshhold;
		progress.current = 0;
		progress.total = -1;
	}

	private function changeRunHandler(v:Bool):Void {
		if (v)
			eReady.dispatch();
		else
			eLoad.dispatch();
	}

	private function updateVideoLoadPercentage():Void {
		if (element.duration == 0) {
			progress.current = 0;
		} else if (isReady) {
			progress.total = Std.int(element.duration);
			progress.current = Std.int(element.buffered.end(0));
		}
	}

}