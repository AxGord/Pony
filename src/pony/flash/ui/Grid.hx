package pony.flash.ui;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.geom.Rectangle;
import pony.ui.gui.GridCore;

/**
 * Grid
 * @author AxGord
 */
class Grid extends Sprite {

	public var core: GridCore;

	private final slots: Array<Array<GridSlot>>;

	public function new() {
		super();
		slots = [];
	}

	public function init(core: GridCore): Void {
		this.core = core;
		core.setTotal(width, height);
		for (_ in 0...numChildren) removeChildAt(0);
		for (iy in 0...core.cy) {
			final a: Array<GridSlot> = [];
			for (ix in 0...core.cx) {
				final g: GridSlot = new GridSlot();
				addChild(g);
				g.x = ix * core.slotWidth;
				g.y = iy * core.slotHeight;
				a.push(g);
			}
			slots.push(a);
		}
		core.makeMark = makeMark;
	}

	private function makeMark(x: Int, y: Int, state: Bool): Void slots[x][y].mark = state;

}
