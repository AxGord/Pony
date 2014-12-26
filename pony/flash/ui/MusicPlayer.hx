package pony.flash.ui;

import flash.display.MovieClip;
import flash.text.TextField;
import pony.flash.ui.Button;
import pony.flash.ui.SongPlayer;
import pony.geom.Point;
import pony.ui.ButtonCore;
import pony.ui.SwitchableList;



/**
 * MusicPlayer
 * @author AxGord
 */
class MusicPlayer extends SongPlayer {

	@:st(set) private var song:MovieClip;
	
	private var songClass:Class<MovieClip>;
	private var beginPoint:Point<Float>;
	private var songHeight:Float;
	private var sw:SwitchableList;
	
	private var songList:List<MovieClip> = new List();
	private var currentList:Array<SongInfo>;
	
	override private function init() {
		super.init();
		songClass = Type.getClass(song);
		beginPoint = {x: song.x, y: song.y};
		songHeight = song.height;
		removeChild(song);
		song = null;
	}
	
	
	public function loadPlaylist(pl:Array<SongInfo>):Void {
		if (visible) unloadPlaylist();
		visible = true;
		currentList = pl;
		var bcs:Array<ButtonCore> = [];
		var i = 0;
		for (e in pl) {
			var o:MovieClip = Type.createInstance(songClass, []);
			o.x = beginPoint.x;
			o.y = beginPoint.y + i * songHeight;
			addChild(o);
			songList.push(o);
			var b:Button = untyped o.b;
			bcs.push(b.core);
			var t:TextField = untyped o.t;
			t.text = SongPlayer.formatSong(e);
			t.mouseEnabled = false;
			i++;
		}
		sw = new SwitchableList(bcs);
		sw.change << select;
		
	}
	
	public function select(n:Int):Void {
		var song = currentList[n];
		loadSong(song);
	}
	
	public function unloadPlaylist():Void {
		visible = false;
	}
}