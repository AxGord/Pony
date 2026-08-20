package pony.flash.starling.ui;

import starling.display.DisplayObject;
import starling.display.Sprite;

/**
 * StarlingWindows
 */
@:forward(blurOn, blurOff)
abstract StarlingWindows(StarlingWindowsImpl) {

	public inline function new(st: Sprite) this = new StarlingWindowsImpl(st);

	@:arrayAccess public inline function get(key: String): StarlingWindow return this.resolve(key);

}

/**
 * StarlingWindows
 * @author Maletin
 */
@:nullSafety(Strict)
@:final private class StarlingWindowsImpl {

	private final map: Map<String, StarlingWindow> = [];
	private final st: Sprite;

	public function new(st: Sprite) {
		this.st = st;
		final windows: Array<StarlingWindow> = [];
		for (i in 0...st.numChildren) {
			final child = st.getChildAt(i);
			if (Std.is(child, StarlingWindow)) windows.push(cast child);
		}
		for (window in windows) {
			map[window.name] = window;
			window.initm(cast this);
			// TODO With this code buttons don't work. Either fix it or always place windows on top of everything else
			// st.removeChild(window);
			// st.stage.addChild(window);
		}
	}

	@:nullSafety(Off) public inline function resolve(field: String): StarlingWindow return map[field];

	public function blurOn(): Void {
		// var filter = new BlurFilter();
		// filter.quality = 3;
		// switch (st.stage.quality) {
		// case StageQuality.LOW:
		// case StageQuality.MEDIUM:
		// Lib.current.alpha = 0.05;
		// default:
		// Lib.current.filters = [filter];
		// Lib.current.alpha = 0.05;
		// }
		// Lib.current.mouseEnabled = false;
		// Lib.current.mouseChildren = false;
	}

	public function blurOff(): Void {
		// Lib.current.filters = [];
		// Lib.current.alpha = 1;
		// Lib.current.mouseEnabled = true;
		// Lib.current.mouseChildren = true;
	}

}
