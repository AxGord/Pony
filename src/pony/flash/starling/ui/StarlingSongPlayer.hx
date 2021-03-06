package pony.flash.starling.ui;

import pony.events.Signal1;
import pony.flash.FLTools;
import pony.flash.SongPlayerCore;
import pony.time.DeltaTime;
import pony.ui.touch.starling.touchManager.TouchEventType;
import pony.ui.touch.starling.touchManager.TouchManager;
import pony.ui.touch.starling.touchManager.TouchManagerEvent;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Sprite;
import starling.text.TextField;
import starling.textures.TextureSmoothing;

/**
 * StarlingSongPlayer
 * @author AxGord
 */
class StarlingSongPlayer extends Sprite {

	private var playBar: StarlingBar;
	private var loadProgress: StarlingProgressBar;
	private var bPlay: StarlingButton;
	private var tTitle: TextField;
	private var bMute: StarlingButton;
	private var volume: StarlingBar;
	private var tTime: TextField;

	public var core: SongPlayerCore;

	public function new(source: Sprite) {
		super();

		addChild(source);

		playBar = untyped source.getChildByName('playBar');
		loadProgress = untyped source.getChildByName('loadProgress');

		bPlay = untyped source.getChildByName('bPlay');
		tTitle = untyped source.getChildByName('tTitle');
		bMute = untyped source.getChildByName('bMute');
		volume = untyped source.getChildByName('volume');
		tTime = untyped source.getChildByName('tTime');

		DeltaTime.fixedUpdate < init;
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
		// tTime.mouseEnabled = false;
		tTime.text = '';
		volume.value = 0.8;
		volume.onDynamic << core.set_volume;
		playBar.onDynamic << core.set_position;
		bMute.core.onClick.add(core.switchMute);
		bPlay.core.onClick.add(core.switchPlay);
	}

}