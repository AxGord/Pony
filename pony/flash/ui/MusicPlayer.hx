package pony.flash.ui;

import flash.display.MovieClip;
import flash.text.TextField;
import pony.flash.ui.Button;
import pony.flash.ui.SongPlayer;
import pony.geom.Point;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SwitchableList;

import pony.flash.SongPlayerCore;

/**
 * MusicPlayer
 * @author AxGord
 */
class MusicPlayer extends SongPlayer {
#if !starling
	@:st(set) private var song:MovieClip;
	
	private var songClass:Class<MovieClip>;
	private var beginPoint:Point<Float>;
	private var songHeight:Float;
	private var sw:SwitchableList;
	
	private var songList:List<MovieClip> = new List();
	private var currentList:Array<SongInfo>;
	
	override private function init() {
		visible = false;
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
			var t:TextField = untyped o.tTitle;
			t.text = SongPlayerCore.formatSong(e);
			t.mouseEnabled = false;
			var t:TextField = untyped o.tTime;
			t.text = e.length;
			t.mouseEnabled = false;
			i++;
		}
		sw = new SwitchableList(bcs);
		sw.change << select;
		core.loadSong(pl[0]);
		core.onComplite << sw.next;
	}
	
	public function select(n:Int):Void {
		var song = currentList[n];
		core.loadSong(song);
	}
	
	public function unloadPlaylist():Void {
		visible = false;
	}
#end
}