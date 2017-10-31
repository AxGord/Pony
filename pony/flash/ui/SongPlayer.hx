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
package pony.flash.ui;

import flash.display.MovieClip;
import flash.text.TextField;
import pony.flash.SongPlayerCore;
import pony.time.DeltaTime;

/**
 * SongPlayer
 * @author AxGord
 */
class SongPlayer extends MovieClip implements FLStage {
#if !starling

	@:stage private var playBar:Bar;
	@:stage private var loadProgress:ProgressBar;
	@:stage private var bPlay:Button;
	@:stage private var tTitle:TextField;
	@:stage private var bMute:Button;
	@:stage private var volume:Bar;
	@:stage private var tTime:TextField;
	
	public var core:SongPlayerCore;
	
	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
		core = new SongPlayerCore();
		core.onPlay << function() bPlay.core.mode = 1;
		core.onPause << function() bPlay.core.mode = 0;
		core.onVolume << function(v:Float) volume.value = v;
		core.onMute << function() bMute.core.mode = 1;
		core.onUnmute << function() bMute.core.mode = 0;
		core.onLoadprogress << function(v:Float) loadProgress.value = v;
		core.onPosition << function(v:Float) playBar.value = v;
		core.onTextUpdate << function(t:String) tTitle.text = t;
		core.onTimeTextUpdate << function(t:String) tTime.text = t;
	}
	
	private function init() {
		tTime.mouseEnabled = false;
		tTime.text = '';
		volume.value = 0.8;
		volume.onDynamic << core.set_volume;
		playBar.onDynamic << core.set_position;
		bMute.core.onClick.add(core.switchMute);
		bPlay.core.onClick.add(core.switchPlay);
	}
	
#end
}