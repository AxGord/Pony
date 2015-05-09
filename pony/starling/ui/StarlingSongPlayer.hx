package pony.starling.ui;

import pony.events.Signal;
import pony.events.Signal1;
import pony.flash.FLTools;
import pony.flash.SongPlayerCore;
import pony.time.DeltaTime;
import pony.touchManager.TouchEventType;
import pony.touchManager.TouchManager;
import pony.touchManager.TouchManagerEvent;
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

	private var playBar:StarlingBar;
	private var loadProgress:StarlingProgressBar;
	private var bPlay:StarlingButton;
	private var tTitle:TextField;
	private var bMute:StarlingButton;
	private var volume:StarlingBar;
	private var tTime:TextField;
	
	public var core:SongPlayerCore;
	
	public function new(source:Sprite) {
		super();
		
		addChild(source);
		
		playBar = untyped source.getChildByName("playBar");
		loadProgress = untyped source.getChildByName("loadProgress");
		
		bPlay = untyped source.getChildByName("bPlay");
		tTitle = untyped source.getChildByName("tTitle");
		bMute = untyped source.getChildByName("bMute");
		volume = untyped source.getChildByName("volume");
		tTime = untyped source.getChildByName("tTime");
		
		DeltaTime.fixedUpdate < init;
		core = new SongPlayerCore();
		core.onPlay << function() bPlay.core.mode = 2;
		core.onPause << function() bPlay.core.mode = 0;
		core.onVolume << function(v:Float) volume.value = v;
		core.onMute << function() bMute.core.mode = 2;
		core.onUnmute << function() bMute.core.mode = 0;
		core.onLoadprogress << function(v:Float) loadProgress.value = v;
		core.onPosition << function(v:Float) playBar.value = v;
		core.onTextUpdate << function(t:String) tTitle.text = t;
		core.onTimeTextUpdate << function(t:String) tTime.text = t;
	}
	
	private function init() {
		//tTime.mouseEnabled = false;
		tTime.text = '';
		volume.value = 0.8;
		volume.onDynamic << core.set_volume;
		playBar.onDynamic << core.set_position;
		bMute.core.click.add(core.switchMute);
		bPlay.core.click.add(core.switchPlay);
	}
	
}