package pony.pixi.ui;

import pixi.core.display.Container;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.IntervalLayoutCore;

/**
 * IntervalLayout
 * @author AxGord <axgord@gmail.com>
 */
class IntervalLayout extends BaseLayout<IntervalLayoutCore<Container>> {

	public function new(interval:Int, vert:Bool = false, ?border:Border<Int>, ?align:Align) {
		layout = new IntervalLayoutCore<Container>(interval, vert, border, align);
		super();
	}
	
}