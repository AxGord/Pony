package pony.openfl.ui;

import openfl.display.DisplayObject;
import pony.geom.Align;
import pony.ui.gui.IntervalLayoutCore;
import pony.openfl.ui.BaseLayout;

class IntervalLayout extends BaseLayout<IntervalLayoutCore<DisplayObject>> {
	public function new (interval : Int, vert : Bool = false, ?align:Align) {
		layout = new IntervalLayoutCore<DisplayObject>(interval, vert, align);
		super();
	}
}