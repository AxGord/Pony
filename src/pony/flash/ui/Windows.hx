package pony.flash.ui;

import flash.display.BlendMode;
import flash.display.MovieClip;
import flash.filters.BlurFilter;
import flash.display.StageQuality;
import flash.Lib;

using pony.flash.FLTools;

/**
 * Windows
 * @author AxGord <axgord@gmail.com>
 */
@:forward(blurOn, blurOff)
abstract Windows(WindowsImpl) {

	public inline function new(st: MovieClip) this = new WindowsImpl(st);

	@:op(a.b) public inline function fieldRead(name: String): Window return this.resolve(name);

}

@:nullSafety(Strict)
private class WindowsImpl {

	private var map: Map<String, Window>;
	private var st: MovieClip;

	public function new(st: MovieClip) {
		map = new Map<String, Window>();
		this.st = st;
		var chs = [for (e in st.childrens()) e];
		for (ch in chs)
			if (Std.is(ch, Window)) {
				var e: Window = cast ch;
				map.set(e.name, e);
				e.initm(cast this);
				st.removeChild(e);
				st.stage.addChild(e);
			}
	}

	@:nullSafety(Off) public inline function resolve(field: String): Window return map.get(field);

	public function blurOn(): Void {
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
		Lib.current.mouseEnabled = false;
		Lib.current.mouseChildren = false;
	}

	public function blurOff(): Void {
		Lib.current.filters = [];
		Lib.current.alpha = 1;
		Lib.current.mouseEnabled = true;
		Lib.current.mouseChildren = true;
	}

}