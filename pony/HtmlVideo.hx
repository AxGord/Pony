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
package pony;

import js.html.CSSStyleDeclaration;
import js.html.VideoElement;
import js.html.SourceElement;
import pony.events.Signal0;
import pony.time.DTimer;

typedef HtmlVideoOptions = {
    ?bufferingTreshhold: Float,
    ?retryDelay: Int,
    ?maxRetries: Int,
    ?playDelay: Int
}

/**
 * HtmlVideo
 * @author AxGord <axgord@gmail.com>
 */
class HtmlVideo implements pony.magic.HasSignal {

    @:auto public var onClick:Signal0;
    @:auto public var onShow:Signal0;
    @:auto public var onHide:Signal0;
    @:auto public var onEnd:Signal0;

    private var options:HtmlVideoOptions = {
        bufferingTreshhold: 0.5,
        retryDelay: 3000,
        maxRetries: 4,
        playDelay: 500
    };

    public var visible(get, never):Bool;

    public var videoElement(default, null):VideoElement;
    public var style(get, never):CSSStyleDeclaration;

    private var videoSource:SourceElement;
    private var videoLoadPercentage:Float = 0;
    private var retryCount:Int = 0;
    private var startPercent:Float = 0;
    private var elementVisible(get, set):Bool;

    public function new(?options:HtmlVideoOptions) {
        if (options != null) {
            if (options.bufferingTreshhold != null)
                this.options.bufferingTreshhold = options.bufferingTreshhold;
            if (options.retryDelay != null)
                this.options.retryDelay = options.retryDelay;
            if (options.maxRetries != null)
                this.options.maxRetries = options.maxRetries;
        }

		videoElement = cast js.Browser.document.createElement('video');
        videoElement.setAttribute("playsinline", "playsinline"); // for ios
        videoElement.muted = true; // must be muted to play on mobiles
        videoElement.autoplay = true; // for mobiles + desktop
        videoElement.controls = false;

        videoElement.addEventListener('loadeddata', videoLoaddataHandler);
        videoElement.addEventListener('canplay', videoCanplayHandler);
        videoElement.addEventListener('click', videoClickHandler);
		videoElement.addEventListener('ended', videoEndHandler);
		videoElement.addEventListener('pause', videoPauseHandler);
		videoElement.addEventListener('progress', videoProgessHandler);

        elementVisible = false;
    }

    @:extern private inline function get_visible():Bool return elementVisible;

    @:extern public inline function appendTo(parent:js.html.DOMElement):Void parent.appendChild(videoElement);
    @:extern private inline function get_style():CSSStyleDeclaration return videoElement.style;

    @:extern private inline function get_elementVisible():Bool return videoElement.style.display == 'block';
    
    private function set_elementVisible(v:Bool):Bool {
        if (v) {
            videoElement.style.display = 'block';
            eShow.dispatch();
        } else {
            videoElement.style.display = 'none';
            eHide.dispatch();
        }
        return v;
    }

    public function loadVideo(url:String, startPercent:Float = 0):Void {
        elementVisible = false;
        this.startPercent = startPercent;

        if (videoSource != null) {
            videoSource.removeEventListener('error', videoSourceErrorHandler);
            videoElement.removeChild(videoSource);
        }

        videoSource = cast js.Browser.document.createElement('source'); // must play from <source> not .src coz mobile browsers are retarded
        videoSource.addEventListener('error', videoSourceErrorHandler);
        videoSource.src = url;
        videoElement.appendChild(videoSource);

        updateVideoLoadPercentage();
        playstopDelay(playVideo);
    }

    @:extern private inline function playstopDelay(cb:Void->Void):Void DTimer.fixedDelay(options.playDelay, cb);

    private function videoSourceErrorHandler(e:js.Error):Void DTimer.fixedDelay(options.retryDelay, retryConnect);

    private function retryConnect():Void {
        if (retryCount < options.maxRetries) {
            loadVideo(videoSource.src, startPercent);
            retryCount++;
        }
    }

    private function videoLoaddataHandler():Void {
        updateVideoLoadPercentage();
        if (isVideoLoadedThreshold()) videoLoaded();
    }

    private function videoCanplayHandler():Void {
        updateVideoLoadPercentage();
        if (isVideoLoadedThreshold() && elementVisible) playVideo();
    }

    private function videoClickHandler():Void eClick.dispatch();

    private function videoEndHandler():Void {
        hideVideo();
        eEnd.dispatch();
    }

    private function videoPauseHandler():Void if (elementVisible) playVideo();

    private function videoProgessHandler():Void {
        updateVideoLoadPercentage();
        if (isVideoLoadedThreshold()) {
            showVideo();
            videoCanplayHandler();
        }
    }

    private function updateVideoLoadPercentage():Void {
        if (videoElement.buffered.length > 0)// if video has buffered yet
            videoLoadPercentage = videoElement.buffered.end(0) / videoElement.duration;
    }

    @:extern private inline function isVideoLoadedThreshold():Bool return videoLoadPercentage >= options.bufferingTreshhold;

    private function videoLoaded():Void {
        retryCount = 0;
        videoElement.currentTime = videoElement.duration * startPercent;
        updateVideoLoadPercentage();
        playVideo();
        showVideo();
    }

    private function showVideo():Void {
        updateVideoLoadPercentage();
        if (isVideoLoadedThreshold()) elementVisible = true;
    }

    private function hideVideo():Void {
        playstopDelay(videoElement.pause);
        elementVisible = false;
    }

    private function playVideo():Void if (isVideoLoadedThreshold()) videoElement.play();

}