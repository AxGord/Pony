package pony.flash.ui;

import flash.display.MovieClip;
import flash.text.TextField;
import pony.flash.SongPlayerCore;
import pony.flash.ui.Button;
import pony.flash.ui.SongPlayer;
import pony.geom.Point;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SwitchableList;

/**
 * MusicPlayer
 * @author AxGord
 */
class MusicPlayer extends SongPlayer {

	#if !starling
	private final songList: List<MovieClip> = new List();

	@:stage(set) private var song: MovieClip;
	private var songClass: Class<MovieClip>;
	private var beginPoint: Point<Float>;
	private var songHeight: Float;
	private var sw: SwitchableList;
	private var currentList: Array<SongInfo>;

	public function loadPlaylist(pl: Array<SongInfo>): Void {
		if (visible) unloadPlaylist();
		visible = true;
		currentList = pl;
		final bcs: Array<ButtonCore> = [];
		var i: Int = 0;
		for (e in pl) {
			final o: MovieClip = Type.createInstance(songClass, []);
			o.x = beginPoint.x;
			o.y = beginPoint.y + i * songHeight;
			addChild(o);
			songList.push(o);
			final b: Button = untyped o.b;
			bcs.push(b.core);
			final t: TextField = untyped o.tTitle;
			t.text = SongPlayerCore.formatSong(e);
			t.mouseEnabled = false;
			final t: TextField = untyped o.tTime;
			t.text = e.length;
			t.mouseEnabled = false;
			i++;
		}
		sw = new SwitchableList(bcs);
		sw.change << select;
		core.loadSong(pl[0]);
		core.onComplete << sw.next;
	}

	public function select(n: Int): Void {
		final song = currentList[n];
		core.loadSong(song);
	}

	public inline function unloadPlaylist(): Void {
		visible = false;
	}

	override private function init(): Void {
		visible = false;
		super.init();
		songClass = Type.getClass(song);
		beginPoint = { x: song.x, y: song.y };
		songHeight = song.height;
		removeChild(song);
		song = null;
	}
	#end

}
