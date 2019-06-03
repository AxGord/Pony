package pony.heaps.ui.gui.layout;

import h2d.Object;
import pony.geom.Align;
import pony.geom.Border;
import pony.ui.gui.RubberLayoutCore;

/**
 * RubberLayout
 * @author AxGord <axgord@gmail.com>
 */
class RubberLayout extends BaseLayout<RubberLayoutCore<Object>> {
	
	public function new(layoutWidth:Float, layoutHeight:Float, vert:Bool = false, ?border:Border<Int>, padding:Bool = true, ?align:Align) {
		layout = new RubberLayoutCore<Object>(vert, border, padding, align);
		layout.width = layoutWidth;
		layout.height = layoutHeight;
		super();
	}
	
}