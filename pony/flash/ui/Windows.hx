package pony.flash.ui;
import flash.display.BlendMode;
import flash.display.MovieClip;
import flash.filters.BlurFilter;
import flash.Lib;
import flash.display.StageQuality;
using pony.flash.FLTools;
/**
 * Windows
 * @author AxGord <axgord@gmail.com>
 */
class Windows implements Dynamic<Window> {

	private var map:Map<String, Window>;
	private var st:MovieClip;
	
	public function new(st:MovieClip) {
		map = new Map<String, Window>();
		this.st = st;
		var chs = [for (e in st.childrens()) e];
		for (ch in chs) if (Std.is(ch, Window)) {
			var e:Window = cast ch;
			map.set(e.name, e);
			e.initm(this);
			st.removeChild(e);
			st.stage.addChild(e);
		}
	}
	
	inline public function resolve(field:String):Window return map.get(field);
	
	public function blurOn():Void {
		var filter = new BlurFilter();
		filter.quality = 3;
		switch (st.stage.quality) {
			case StageQuality.LOW:
			case StageQuality.MEDIUM:
				Lib.current.alpha = 0.05;
			default:
				Lib.current.filters = [filter];
				Lib.current.alpha = 0.05;		
		}
		//Lib.current.blendMode = BlendMode.HARDLIGHT;
		Lib.current.mouseEnabled = false;
		Lib.current.mouseChildren = false;
	}
	
	public function blurOff():Void {
		Lib.current.filters = [];
		Lib.current.alpha = 1;
		//Lib.current.blendMode = BlendMode.NORMAL;
		Lib.current.mouseEnabled = true;
		Lib.current.mouseChildren = true;
	}
	
}