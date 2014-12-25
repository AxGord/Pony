package pony.flash.ui;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.media.Sound;
import flash.net.URLRequest;
import flash.text.TextField;
import pony.flash.ui.Button;
import pony.flash.ui.ProgressBar;
import pony.flash.ui.ScrollBar;
import pony.geom.Point;
import pony.time.Time;
import pony.ui.ButtonCore;
import pony.ui.SwitchableList;

typedef SongInfo = {
	author: String,
	title: String,
	length: Time,
	file: String
}

/**
 * MusicPlayer
 * @author AxGord
 */
class MusicPlayer extends MovieClip implements FLSt {

	@:st private var progress:ProgressBar;
	@:st private var bPlay:Button;
	@:st private var tTitle:TextField;
	@:st private var song:MovieClip;
	@:st private var bMute:Button;
	@:st private var volume:ScrollBar;
	
	private var songClass:Class<MovieClip>;
	private var beginPoint:Point<Float>;
	private var songHeight:Float;
	private var sw:SwitchableList;
	
	private var songList:List<MovieClip> = new List();
	private var currentList:Array<SongInfo>;
	
	public function new() {
		super();
		visible = false;
		FLTools.init < init;
	}
	
	private function init() {
		volume.total = 100;
		volume.update.add(volumeHandler);
		if (bMute != null) bMute.core.click.add(volume.set_position);
		songClass = Type.getClass(song);
		beginPoint = {x: song.x, y: song.y};
		songHeight = song.height;
		removeChild(song);
		//song = null;
		//bPlay.sw = [2, 1, 0];
		//bPlay.core.onMode.sub(2).add(play);
		//bPlay.core.onMode.sub(0).add(pause);
	}
	
	public function mute():Void {
		volume.position = 0;
	}
	
	private function volumeHandler(v:Float):Void {
		v /= 100;
		
	}
	
	public function loadPlaylist(pl:Array<SongInfo>):Void {
		if (visible) unloadPlaylist();
		visible = true;
		currentList = pl;
		var bcs:Array<ButtonCore> = [];
		var i = 0;
		for (e in pl) {
			var o = Type.createInstance(songClass, []);
			o.x = beginPoint.x;
			o.y = beginPoint.y + i * songHeight;
			addChild(o);
			songList.push(o);
			var b:ButtonCore = untyped o.b.core;
			bcs.push(b);
			i++;
		}
		sw = new SwitchableList(bcs);
		sw.change << select;
	}
	
	public function select(n:Int):Void {
		var song = currentList[n];
		tTitle.text = (song.author != null ? song.author + ' - ' : '') + song.title;
		var req:URLRequest = new URLRequest(song.file);
		var sound:Sound = new Sound(req);
		
	}
	
	public function unloadPlaylist():Void {
		visible = false;
	}
	/*
	public function play():Void {
		
	}
	
	public function pause():Void {
		
	}
	*/
}