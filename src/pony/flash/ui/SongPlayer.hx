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
	@:stage private var playBar: Bar;
	@:stage private var loadProgress: ProgressBar;
	@:stage private var bPlay: Button;
	@:stage private var tTitle: TextField;
	@:stage private var bMute: Button;
	@:stage private var volume: Bar;
	@:stage private var tTime: TextField;

	public var core: SongPlayerCore;

	public function new() {
		super();
		DeltaTime.fixedUpdate.once(init, -1);
		core = new SongPlayerCore();
		core.onPlay << function() bPlay.core.mode = 1;
		core.onPause << function() bPlay.core.mode = 0;
		core.onVolume << function(v: Float) volume.value = v;
		core.onMute << function() bMute.core.mode = 1;
		core.onUnmute << function() bMute.core.mode = 0;
		core.onLoadprogress << function(v: Float) loadProgress.value = v;
		core.onPosition << function(v: Float) playBar.value = v;
		core.onTextUpdate << function(t: String) tTitle.text = t;
		core.onTimeTextUpdate << function(t: String) tTime.text = t;
	}

	private function init(): Void {
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