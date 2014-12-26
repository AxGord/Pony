package pony.flash.ui;
import flash.display.MovieClip;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.text.TextField;
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

	@:st private var progress:ProgressBar;
	@:st private var bPlay:Button;
	@:st private var tTitle:TextField;
	@:st private var bMute:Button;
	@:st private var volume:ScrollBar;
	
	public var isPlay(get, set):Bool;
	
	public function new() {
		super();
		visible = false;
		FLTools.init < init;
	}
	
	private function init() {
		volume.total = 500;
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
		v /= 500;
		
	}
	
	public static function formatSong(song:SongInfo):String return (song.author != null ? song.author + ' - ' : '') + song.title;
	
	public function loadSong(song:SongInfo):Void {
		visible = true;
		tTitle.text = SongPlayer.formatSong(song);
		var req:URLRequest = new URLRequest(song.file);
		var sound:Sound = new Sound(req);
		if (isPlay) playSong();
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
	}
	
	private function pauseSong():Void {
		trace('pause song');
	}
	
}