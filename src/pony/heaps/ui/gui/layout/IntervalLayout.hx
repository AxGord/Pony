package pony.heaps.ui.gui.layout;

import h2d.Object;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.IntervalLayoutCore;

/**
 * IntervalLayout
 * @author AxGord <axgord@gmail.com>
 */
@:nullSafety(Strict)
class IntervalLayout extends BaseLayout<IntervalLayoutCore<Object>> {

	public function new(interval: Int, vert: Bool = false, ?border: Border<Int>, ?align: Align, limit: Float = 0, mask: Bool = false) {
		super(new IntervalLayoutCore<Object>(interval, vert, border, align, limit), mask);
	}

}