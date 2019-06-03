package pony.heaps.ui.gui.layout;

import h2d.Object;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.IntervalLayoutCore;

/**
 * IntervalLayout
 * @author AxGord <axgord@gmail.com>
 */
class IntervalLayout extends BaseLayout<IntervalLayoutCore<Object>> {

	public function new(interval:Int, vert:Bool = false, ?border:Border<Int>, ?align:Align) {
		layout = new IntervalLayoutCore<Object>(interval, vert, border, align);
		super();
	}
	
}