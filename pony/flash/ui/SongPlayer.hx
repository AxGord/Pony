package pony.flash.ui;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import flash.text.TextField;
import pony.events.Signal;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.time.DeltaTime;
import pony.time.Time;

typedef SongInfo = {
	?author: String,
	title: String,
	length: Time,
	file: String
}

/**
 * SongPlayer
 * @author AxGord
 */
class SongPlayer extends MovieClip implements FLSt {
#if !starling
	//@:st private var progress:ProgressBar;
	@:st private var playBar:Bar;
	@:st private var loadProgress:ProgressBar;
	@:st private var bPlay:Button;
	@:st private var tTitle:TextField;
	@:st private var bMute:Button;
	@:st private var volume:Bar;
	@:st private var tTime:TextField;
	
	public var isPlay(get, set):Bool;
	public var onComplite:Signal0<SongPlayer>;
	public var onPlay:Signal0<SongPlayer>;
	public var onPause:Signal0<SongPlayer>;
	public var onTextUpdate:Signal1<SongPlayer, String>;
	public var onTimeTextUpdate:Signal1<SongPlayer, String>;
	
	
	private var sound:Sound;
	private var channel:SoundChannel;
	private var pTime:Float = 0;
	private var pVol:Float = 0;
	private var songTotal:Float = 0;
	
	public function new() {
		super();
		onComplite = Signal.create(this);
		onPlay = Signal.create(this);
		onPause = Signal.create(this);
		onTextUpdate = Signal.create(this);
		onTimeTextUpdate = Signal.create(this);
		visible = false;
		FLTools.init < init;
		
	}
	
	private function init() {
		tTime.mouseEnabled = false;
		tTime.text = '';
		volume.value = 0.8;
		volume.on << volumeHandler;
		if (bMute != null) {
			bMute.core.sw = [2, 1, 0];
			bMute.core.onMode.sub(2).add(mute);
			bMute.core.onMode.sub(0).add(unmute);
		}
		bPlay.core.sw = [2, 1, 0];
		bPlay.core.onMode.sub(2).add(playSong);
		bPlay.core.onMode.sub(0).add(pauseSong);
		playBar.on << setPosition;
	}
	
	public function mute():Void {
		pVol = volume.value;
		volume.value = 0;
		volume.on.add(restoreVolume);
	}
	
	private function restoreVolume():Void {
		bMute.core.mode = 0;
	}
	
	public function unmute():Void {
		volume.value = pVol;
		volume.on.remove(restoreVolume);
	}
	
	private function volumeHandler(v:Float):Void {
		if (isPlay) channel.soundTransform = new SoundTransform(v);
	}
	
	public static function formatSong(song:SongInfo):String return (song.author != null ? song.author + ' - ' : '') + song.title;
	
	public function loadSong(song:SongInfo):Void {
		playBar.value = 0;
		if (isPlay) {
			DeltaTime.fixedUpdate >> update;
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
		}
		if (sound != null) {
			sound.removeEventListener(ProgressEvent.PROGRESS, progressHandler);
			try {
				sound.close();
			} catch(_:Dynamic) {}
		}
		pTime = 0;
		visible = true;
		songTotal = song.length;
		tTitle.text = SongPlayer.formatSong(song);
		onTextUpdate.dispatch(tTitle.text);
		tTime.text = song.length.toString();
		onTimeTextUpdate.dispatch(tTime.text);
		sound = new Sound(new URLRequest(song.file));
		sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		if (isPlay) playSong();
	}
	
	private function progressHandler(event:ProgressEvent):Void {
		loadProgress.progress = event.bytesLoaded / event.bytesTotal;
	}
	
	private function soundComplete(event:Event):Void onComplite.dispatch();
	
	private function get_isPlay():Bool return bPlay.core.mode == 2;
	
	private function set_isPlay(b:Bool):Bool {
		var nm = b ? 2 : 0;
		if (nm != bPlay.core.mode) {
			bPlay.core.mode = nm;
			if (b) playSong();
			else pauseSong();
		}
		return b;
	}
	
	private function playSong():Void {
		channel = sound.play(pTime);
		channel.soundTransform = new SoundTransform(volume.value);
		channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		DeltaTime.fixedUpdate << update;
		onPlay.dispatch();
	}
	
	private function pauseSong():Void {
		pTime = channel.position;
		channel.stop();
		DeltaTime.fixedUpdate >> update;
		onPause.dispatch();
	}
	
	public function setPosition(v:Float):Void {
		if (isPlay) {
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			channel = sound.play(v * songTotal);
			channel.soundTransform = new SoundTransform(volume.value);
			channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		} else {
			pTime = v * songTotal;
		}
	}
	
	private function returnUpdate():Void DeltaTime.fixedUpdate << update;
	
	private function update():Void {
		playBar.on >> setPosition;
		var t:String = (channel.position:Time).toString();
		t += ' / ';
		t += (songTotal:Time).toString();
		tTime.text = t;
		onTimeTextUpdate.dispatch(t);
		playBar.value = channel.position / songTotal;
		playBar.on << setPosition;
	}
	
#end
}