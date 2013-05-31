package pony.flash.ui;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.events.Event;
import pony.Rect;
import pony.ui.GridCore;

using pony.flash.FLExtends;

/**
 * ...
 * @author AxGord
 */
class Grid extends Sprite {
	
	private var slots:Array<Array<GridSlot>>;
	
	public var core:GridCore;
	
	public function new() {
		super();
		slots = [];
	}
	
	public function init(core:GridCore):Void {
		this.core = core;
		core.setTotal(width, height);
		
		for (Void in 0...numChildren) removeChildAt(0);
		for (iy in 0...core.cy) {
			var a:Array<GridSlot> = [];
			for (ix in 0...core.cx) {
				var g:GridSlot = new GridSlot();
				addChild(g);
				g.x = ix * core.slotWidth;
				g.y = iy * core.slotHeight;
				a.push(g);
			}
			slots.push(a);
		}
		core.makeMark = makeMark;
	}
	
	private function makeMark(x:Int, y:Int, state:Bool):Void slots[x][y].mark = state;
		
}