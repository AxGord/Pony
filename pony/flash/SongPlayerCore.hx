package pony.flash;

import flash.events.Event;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.magic.HasSignal;
import pony.time.DeltaTime;
import pony.time.Time;

typedef SongInfo = {
	?author: String,
	title: String,
	length: Time,
	file: String
}

/**
 * SongPlayerCore
 * @author AxGord
 */
class SongPlayerCore implements HasSignal {

	public var isPlay(default, set):Bool = false;
	
	@:auto public var onComplete:Signal0;
	@:auto public var onPlay:Signal0;
	@:auto public var onPause:Signal0;
	@:auto public var onVolume:Signal1<Float>;
	@:auto public var onMute:Signal0;
	@:auto public var onUnmute:Signal0;
	@:auto public var onTextUpdate:Signal1<String>;
	@:auto public var onTimeTextUpdate:Signal1<String>;
	@:auto public var onPosition:Signal1<Float>;
	@:auto public var onLoadprogress:Signal1<Float>;
	
	public var volume(default, set):Float = 0.8;
	public var isMute(default, set):Bool = false;
	public var position(default, set):Float = 0;
	
	private var sound:Sound;
	private var channel:SoundChannel;
	private var pTime:Float = 0;
	private var pVol:Float = 0;
	private var songTotal:Float = 0;
	
	public function new() {
		onPosition << setPosition;
	}
	
	public function set_isPlay(b:Bool):Bool {
		if (b == isPlay) return b;
		isPlay = b;
		if (b) playSong();
		else pauseSong();
		return b;
	}
	
	public function set_isMute(b:Bool):Bool {
		if (b == isMute) return b;
		if (b == true) {
			pVol = volume;
			volume = 0;
			isMute = true;
			eMute.dispatch();
		} else {
			isMute = false;
			volume = pVol;
			eUnmute.dispatch();
		}
		return b;
	}
	
	public function set_volume(v:Float):Float {
		if (v == volume) return v;
		if (isMute) {
			pVol = v;
			isMute = false;
		} else {
			volume = v;
			eVolume.dispatch(v);
			if (isPlay && channel != null) channel.soundTransform = new SoundTransform(v);
		}
		return volume;
	}
	
	public function set_position(v:Float):Float {
		if (v == position) return v;
		position = v;
		ePosition.dispatch(v);
		return v;
	}
	
	inline public function mute():Void isMute = true;
	inline public function unmute():Void isMute = false;
	public function switchMute():Void isMute = !isMute;
	public function switchPlay():Void isPlay = !isPlay;
	
	public static function formatSong(song:SongInfo):String return (song.author != null ? song.author + ' - ' : '') + song.title;
	
	private function progressHandler(event:ProgressEvent):Void eLoadprogress.dispatch(event.bytesLoaded / event.bytesTotal);
	private function soundComplete(event:Event):Void eComplete.dispatch();
	
	public function loadSong(song:SongInfo):Void {
		position = 0;
		eLoadprogress.dispatch(0);
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
		songTotal = song.length;
		eTextUpdate.dispatch(formatSong(song));
		eTimeTextUpdate.dispatch(song.length.toString());
		sound = new Sound(new URLRequest(song.file));
		sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		if (isPlay) playSong();
	}
	
	private function playSong():Void {
		channel = sound.play(pTime);
		channel.soundTransform = new SoundTransform(volume);
		channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		DeltaTime.fixedUpdate << update;
		ePlay.dispatch();
	}
	
	private function pauseSong():Void {
		pTime = channel.position;
		channel.stop();
		DeltaTime.fixedUpdate >> update;
		ePause.dispatch();
	}
	
	private function setPosition(v:Float):Void {
		if (isPlay) {
			channel.stop();
			channel.removeEventListener(Event.SOUND_COMPLETE, soundComplete);
			channel = sound.play(v * songTotal);
			channel.soundTransform = new SoundTransform(volume);
			channel.addEventListener(Event.SOUND_COMPLETE, soundComplete);
		} else {
			pTime = v * songTotal;
		}
	}
	
	private function update():Void {
		onPosition >> setPosition;
		var t:String = (channel.position:Time).toString();
		t += ' / ';
		t += (songTotal:Time).toString();
		eTimeTextUpdate.dispatch(t);
		ePosition.dispatch(channel.position / songTotal);
		onPosition << setPosition;
	}
	
}