package pony.flash.ui;
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.net.URLRequest;
import flash.text.TextField;
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

	//@:st private var progress:ProgressBar;
	@:st private var playBar:Bar;
	@:st private var loadProgress:ProgressBar;
	@:st private var bPlay:Button;
	@:st private var tTitle:TextField;
	@:st private var bMute:Button;
	@:st private var volume:ScrollBar;
	
	public var isPlay(get, set):Bool;
	
	private var sound:Sound;
	private var channel:SoundChannel;
	
	public function new() {
		super();
		visible = false;
		FLTools.init < init;
		sound = new Sound();
		sound.addEventListener(ProgressEvent.PROGRESS, progressHandler);
		sound.addEventListener(Event.SOUND_COMPLETE, soundComplete);
	}
	
	private function init() {
		volume.total = 1000;
		
		volume.update.add(volumeHandler);
		if (bMute != null) bMute.core.click.add(volume.set_position);
		bPlay.core.sw = [2, 1, 0];
		bPlay.core.onMode.sub(2).add(playSong);
		bPlay.core.onMode.sub(0).add(pauseSong);
	}
	
	public function mute():Void {
		volume.position = 0;
	}
	
	private function volumeHandler(v:Float):Void {
		v /= 1000;
		trace(v);
	}
	
	public static function formatSong(song:SongInfo):String return (song.author != null ? song.author + ' - ' : '') + song.title;
	
	public function loadSong(song:SongInfo):Void {
		visible = true;
		tTitle.text = SongPlayer.formatSong(song);
		sound.load(new URLRequest(song.file));
		if (isPlay) playSong();
	}
	
	private function progressHandler(event:ProgressEvent):Void {
		loadProgress.progress = event.bytesLoaded / event.bytesTotal;
	}
	
	private function soundComplete(_):Void {
		trace('soundComplete');
	}
	
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
		trace('play song');
		channel = sound.play();
		DeltaTime.fixedUpdate << update;
	}
	
	private function pauseSong():Void {
		trace('pause song');
		channel.stop();
		DeltaTime.fixedUpdate >> update;
	}
	
	private function update():Void {
		//progress.progress = channel.position / sound.length;
		playBar.value = channel.position / sound.length;
		trace(channel.position / sound.length);
	}
	
}