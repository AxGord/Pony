package pony.openfl.ui;

import openfl.display.DisplayObject;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.IntervalLayoutCore;
import pony.openfl.ui.BaseLayout;

/**
 * IntervalLayout
 * @author meerfolk<meerfolk@gmail.com>
 */
class IntervalLayout extends BaseLayout<IntervalLayoutCore<DisplayObject>> {
	public function new (interval : Int, vert : Bool = false, ?border:Border<Int>, ?align:Align) {
		layout = new IntervalLayoutCore<DisplayObject>(interval, vert, border, align);
		super();
	}
}