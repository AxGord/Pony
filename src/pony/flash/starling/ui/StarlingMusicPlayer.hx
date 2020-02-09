package pony.flash.starling.ui;

import pony.time.DeltaTime;
import starling.display.Sprite;
import starling.display.DisplayObject;
import starling.text.TextField;
import pony.flash.SongPlayerCore;
import pony.flash.SongPlayerCore.SongInfo;
import pony.geom.Point;
import pony.ui.gui.ButtonCore;
import pony.ui.gui.SwitchableList;

using pony.flash.starling.utils.StarlingUtils;
using pony.Tools;

/**
 * StarlingMusicPlayer
 * @author AxGord
 */
class StarlingMusicPlayer extends StarlingSongPlayer {

	private var song: DisplayObject;
	private var _b: StarlingButton;
	private var _tTitle: TextField;
	private var _tTime: TextField;

	private var songClass: Class<DisplayObject>;

	private var beginPoint: Point<Float>;
	private var songHeight: Float;
	private var sw: SwitchableList;

	private var songList: List<DisplayObject> = new List();
	private var currentList: Array<SongInfo>;

	private var source: Sprite;

	override public function new(source: Sprite) {
		super(source);
		this.source = source;
		song = untyped source.getChildByName("song");
		_b = untyped song.getChildByName('b');
		_tTitle = untyped song.getChildByName('tTitle');
		_tTime = untyped song.getChildByName('tTime');

	}

	override private function init() {
		visible = false;
		super.init();
		songClass = Type.getClass(song);
		beginPoint = {x: song.x, y: song.y};
		songHeight = song.height;
		source.removeChild(song);
		song = null;
	}

	public function loadPlaylist(pl: Array<SongInfo>): Void {
		if (visible)
			unloadPlaylist();
		visible = true;
		currentList = pl;
		var bcs: Array<ButtonCore> = [];
		var i = 0;
		for (e in pl) {
			var o: Sprite = new Sprite(); // Type.createInstance(songClass, []);
			o.x = beginPoint.x;
			o.y = beginPoint.y + i * songHeight;
			source.addChild(o);
			songList.push(o);

			var b: StarlingButton = _b.clone();
			o.addChild(b);
			bcs.push(b.core);

			var t: TextField = new TextField(Std.int(_tTitle.width), Std.int(_tTitle.height), SongPlayerCore.formatSong(e), _tTitle.fontName,
				_tTitle.fontSize, _tTitle.color, _tTitle.bold);
			t.hAlign = _tTitle.hAlign;
			t.vAlign = _tTitle.vAlign;
			t.x = _tTitle.x;
			t.y = _tTitle.y;
			t.touchable = false;
			o.addChild(t);

			var t: TextField = new TextField(Std.int(_tTime.width), Std.int(_tTime.height), e.length, _tTime.fontName, _tTime.fontSize, _tTime.color,
				_tTime.bold);
			t.hAlign = _tTime.hAlign;
			t.vAlign = _tTime.vAlign;
			t.x = _tTime.x;
			t.y = _tTime.y;
			t.touchable = false;
			o.addChild(t);

			/*

				//var b:StarlingButton = untyped o.b;
				var b:StarlingButton = untyped o.getChildByName('b');
				trace(b);
				bcs.push(b.core);
				var t:TextField = untyped o.tTitle;
				t.text = SongPlayerCore.formatSong(e);
				//t.mouseEnabled = false;
				var t:TextField = untyped o.tTime;
				t.text = e.length;
				//t.mouseEnabled = false;
			 */

			i++;
		}
		sw = new SwitchableList(bcs);
		sw.change << select;
		core.loadSong(pl[0]);
		core.onComplete << sw.next;
	}

	public function select(n: Int): Void {
		var song = currentList[n];
		core.loadSong(song);
	}

	public function unloadPlaylist(): Void {
		visible = false;
	}

}