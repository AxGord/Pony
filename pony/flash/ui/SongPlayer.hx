package pony.flash.ui;

import flash.display.MovieClip;
import flash.text.TextField;
import pony.flash.SongPlayerCore;

/**
 * SongPlayer
 * @author AxGord
 */
class SongPlayer extends MovieClip implements FLSt {
#if !starling

	@:st private var playBar:Bar;
	@:st private var loadProgress:ProgressBar;
	@:st private var bPlay:Button;
	@:st private var tTitle:TextField;
	@:st private var bMute:Button;
	@:st private var volume:Bar;
	@:st private var tTime:TextField;
	
	public var core:SongPlayerCore;
	
	public function new() {
		super();
		FLTools.init < init;
		core = new SongPlayerCore();
		core.onPlay << function() bPlay.core.mode = 2;
		core.onPause << function() bPlay.core.mode = 0;
		core.onVolume << function(v:Float) volume.value = v;
		core.onMute << function() bMute.core.mode = 2;
		core.onUnmute << function() bMute.core.mode = 0;
		core.onLoadprogress << function(v:Float) loadProgress.progress = v;
		core.onPosition << function(v:Float) playBar.value = v;
		core.onTextUpdate << function(t:String) tTitle.text = t;
		core.onTimeTextUpdate << function(t:String) tTime.text = t;
	}
	
	private function init() {
		tTime.mouseEnabled = false;
		tTime.text = '';
		volume.value = 0.8;
		volume.on << core.set_volume;
		playBar.on << core.set_position;
		bMute.core.click.add(core.switchMute);
		bPlay.core.click.add(core.switchPlay);
	}
	
#end
}