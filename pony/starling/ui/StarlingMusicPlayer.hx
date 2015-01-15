package pony.starling.ui;
import starling.display.Sprite;
import starling.display.DisplayObject;
import starling.text.TextField;
import pony.flash.SongPlayerCore;
import pony.flash.SongPlayerCore.SongInfo;
import pony.geom.Point;
import pony.ui.ButtonCore;
import pony.ui.SwitchableList;

/**
 * StarlingMusicPlayer
 * @author AxGord
 */
class StarlingMusicPlayer extends StarlingSongPlayer {

	private var song:DisplayObject;
	
	private var songClass:Class<DisplayObject>;
	private var beginPoint:Point<Float>;
	private var songHeight:Float;
	private var sw:SwitchableList;
	
	private var songList:List<DisplayObject> = new List();
	private var currentList:Array<SongInfo>;
	
	override public function new(source:Sprite) {
		super(source);
		song = untyped source.getChildByName("song");
	}
		
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
			var o:DisplayObject = Type.createInstance(songClass, []);
			o.x = beginPoint.x;
			o.y = beginPoint.y + i * songHeight;
			addChild(o);
			songList.push(o);
			var b:StarlingButton = untyped o.b;
			bcs.push(b.core);
			var t:TextField = untyped o.tTitle;
			t.text = SongPlayerCore.formatSong(e);
			//t.mouseEnabled = false;
			var t:TextField = untyped o.tTime;
			t.text = e.length;
			//t.mouseEnabled = false;
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
	
}