package pony.flash.ui;

import flash.display.MovieClip;

/**
 * GridSlot
 * @author AxGord
 */
class GridSlot extends MovieClip {
	
	public var mark(default, set):Bool;
	
	public function new() {
		super();
		stop();
	}
	
	private inline function set_mark(b:Bool):Bool {
		gotoAndStop(b ? 2 : 1);
		return mark = b;
	}
	
}