package pony.flash;

import flash.events.Event;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;
import pony.events.Signal;
import pony.events.Signal0;
import pony.events.Signal1;
import pony.flash.ui.SongPlayer;
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
class SongPlayerCore {

	public var isPlay(default, set):Bool = false;
	
	public var onComplite:Signal0<SongPlayerCore>;
	public var onPlay:Signal0<SongPlayerCore>;
	public var onPause:Signal0<SongPlayerCore>;
	public var onVolume:Signal1<SongPlayerCore, Float>;
	public var onMute:Signal0<SongPlayerCore>;
	public var onUnmute:Signal0<SongPlayerCore>;
	public var onTextUpdate:Signal1<SongPlayerCore, String>;
	public var onTimeTextUpdate:Signal1<SongPlayerCore, String>;
	public var onPosition:Signal1<SongPlayerCore, Float>;
	public var onLoadprogress:Signal1<SongPlayerCore, Float>;
	
	public var volume(default, set):Float = 0.8;
	public var isMute(default, set):Bool = false;
	public var position(default, set):Float = 0;
	
	private var sound:Sound;
	private var channel:SoundChannel;
	private var pTime:Float = 0;
	private var pVol:Float = 0;
	private var songTotal:Float = 0;
	
	public function new() {
		onComplite = Signal.create(this);
		onPlay = Signal.create(this);
		onPause = Signal.create(this);
		onVolume = Signal.create(this);
		onMute = Signal.create(this);
		onUnmute = Signal.create(this);
		onTextUpdate = Signal.create(this);
		onTimeTextUpdate = Signal.create(this);
		onPosition = Signal.create(this);
		onLoadprogress = Signal.create(this);
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
			onMute.dispatch();
		} else {
			isMute = false;
			volume = pVol;
			onUnmute.dispatch();
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
			onVolume.dispatch(v);
			if (isPlay && channel != null) channel.soundTransform = new SoundTransform(v);
		}
		return volume;
	}
	
	public function set_position(v:Float):Float {
		if (v == position) return v;
		position = v;
		onPosition.dispatch(v);
		return v;
	}
	
	inline public function mute():Void isMute = true;
	inline public function unmute():Void isMute = false;
	public function switchMute():Void isMute = !isMute;
	public function switchPlay():Void isPlay = !isPlay;
	
	public static function formatSong(song:SongInfo):String return (song.author != null ? song.author + ' - ' : '') + song.title;
	
	private function progressHandler(event:ProgressEvent):Void onLoadprogress.dispatch(event.bytesLoaded / event.bytesTotal);
	private function soundComplete(event:Event):Void onComplite.dispatch();
	
	public function loadSong(song:SongInfo):Void {
		position = 0;
		onLoadprogress.dispatch(0);
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
		onTextUpdate.dispatch(formatSong(song));
		onTimeTextUpdate.dispatch(song.length.toString());
		sound = new Sound(new URLRequest(song.file));
		sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		if (isPlay) playSong();
	}
	
	private function playSong():Void {
		channel = sound.play(pTime);
		channel.soundTransform = new SoundTransform(volume);
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
		onTimeTextUpdate.dispatch(t);
		onPosition.dispatch(channel.position / songTotal);
		onPosition << setPosition;
	}
}